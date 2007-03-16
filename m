Return-Path: <linux-kernel-owner+w=401wt.eu-S933591AbXCPLkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933591AbXCPLkh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 07:40:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933593AbXCPLkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 07:40:37 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:26276 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933594AbXCPLkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 07:40:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WMwg8G1/YSwB5+Z/hf/DguMol87sbKzoF6WDEgFVaVG/VkJBxyKghiv+3jJ0q4VeOu2kzyNrwpKEBIvzqJn53osRQL5MaYMYdOMoQQi3UQXXiLbFsmpIiA5Bk1OdiJoqB51u78Q0C3dV+qzatDmk+zKxAHAcn2bk7/rBKaGG0b4=
Message-ID: <b647ffbd0703160440sd678cedsc8406ef2b1f030c0@mail.gmail.com>
Date: Fri, 16 Mar 2007 12:40:33 +0100
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Pavel Emelianov" <xemul@sw.ru>
Subject: Re: [RFC] kernel/pid.c pid allocation wierdness
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <45FA7823.2040104@sw.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <45F7A4B3.5040005@sw.ru> <m16493rk18.fsf@ebiederm.dsl.xmission.com>
	 <20070314153341.GA770@tv-sign.ru> <45FA7823.2040104@sw.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/03/07, Pavel Emelianov <xemul@sw.ru> wrote:
> Oleg Nesterov wrote:
> > On 03/14, Eric W. Biederman wrote:
> >> Pavel Emelianov <xemul@sw.ru> writes:
> >>
> >>> Hi.
> >>>
> >>> I'm looking at how alloc_pid() works and can't understand
> >>> one (simple/stupid) thing.
> >>>
> >>> It first kmem_cache_alloc()-s a strct pid, then calls
> >>> alloc_pidmap() and at the end it taks a global pidmap_lock()
> >>> to add new pid to hash.
> >
> > We need some global lock. pidmap_lock is already here, and it is
> > only used to protect pidmap->page allocation. Iow, it is almost
> > unused. So it was very natural to re-use it while implementing
> > pidrefs.
> >
> >>> The question is - why does alloc_pidmap() use at least
> >>> two atomic ops and potentially loop to find a zero bit
> >>> in pidmap? Why not call alloc_pidmap() under pidmap_lock
> >>> and find zero pid in pidmap w/o any loops and atomics?
> >
> > Currently we search for zero bit lockless, why do you want
> > to do it under spin_lock ?
>
> Search isn't lockless. Look:
>
> while (1) {
>    if (!test_and_set_bit(...)) {
>        atomic_dec(&nr_free);
>        return pid;
>    }
> we use two atomic operations to find and set a bit in a map.

While you may have a few concurrent threads competing for the same
"offset" and "pid" in the loop - e.g. at point [1] (see below), only
one will succeed with "registering" it due to the atomicity of
test_and_set_bit() and so only this one will get at point [2] with the
"pid".

The rest of the "unlucky" threads will either

(i) compete for another "offset" -> "pid" (as described above);
(ii) leave the loop when one of the conditions of while() becomes
"false" -> e.g. there are no more free slots in this map.

                if (likely(atomic_read(&map->nr_free))) {
                        do {
                                // [1]
                                if (!test_and_set_bit(offset, map->page)) {
                                // [2]
                                        atomic_dec(&map->nr_free);
                                        pid_ns->last_pid = pid;
                                        return pid;
                                }
                                offset = find_next_offset(map, offset);
                                pid = mk_pid(pid_ns, map, offset);
                        /*
                         * find_next_offset() found a bit, the pid from it
                         * is in-bounds, and if we fell back to the last
                         * bitmap block and the final block was the same
                         * as the starting point, pid is before last_pid.
                         */
                        } while (offset < BITS_PER_PAGE && pid < pid_max &&
                                        (i != max_scan || pid < last ||
                                            !((last+1) & BITS_PER_PAGE_MASK)));
                }

>    ...

>
> > Oleg.
> >
> >

-- 
Best regards,
Dmitry Adamushko
