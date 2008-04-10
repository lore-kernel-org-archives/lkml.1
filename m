Return-Path: <linux-kernel-owner+w=401wt.eu-S1756730AbYDJMK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730AbYDJMK1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 08:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755198AbYDJMKP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 08:10:15 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:33637 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754662AbYDJMKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 08:10:14 -0400
Date: Thu, 10 Apr 2008 07:10:09 -0500
From: Paul Jackson <pj@sgi.com>
To: "Bert Wesarg" <bert.wesarg@googlemail.com>
Cc: travis@sgi.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] x86: add cpus_scnprintf function v3
Message-Id: <20080410071009.a5232b12.pj@sgi.com>
In-Reply-To: <36ca99e90804091051k7c2cc97neba0ca1967625433@mail.gmail.com>
References: <20080408184301.651388000@polaris-admin.engr.sgi.com>
	<36ca99e90804091051k7c2cc97neba0ca1967625433@mail.gmail.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike wrote:
>  Part of the change is readability, but also looking towards the future
>  of 16k/64k/??? # of cpus, the straight mask approach will overflow the
>  PAGE_SIZE buffer provided (though some pathological cases will overflow
>  the range method as well.)

Bert wrote:
> Btw, I think you can now push for a deprecation of the 'old' mask
> attributes, with the justification you have given above. The other
> possibility is to change sysfs to provide bigger attribute buffers
> (CCed Greg for this).

Note what Mike said -- some pathological cases will overflow the range
(what I call "list") format as well.

Indeed, the worst case "list" format is worse than the worst case "mask"
format.  Masks take a constant 9 chars per 32 bits, or 9/32 chars/bit.

Worst case lists involve every other CPU or node (all the even ones, or
all the odd ones.)  For CPUs or Nodes that take five decimal digits
(10000 to 65535 -- some of these are u16 kernel types internall) this
amounts to 6 chars every 2 possible values, or 3 chars/bit, which is
quite a bit more than 9/32 chars/bit.

For example, the list of odd CPUs from 1 to 65535 takes 191053
characters:

  1,3,5,7,9,11,13,15,17,19,...,65517,65519,65521,65523,65525,65527,65529,65531,65533,65535

This will overflow any ordinary page size.  The corresponding mask
takes only 18432 characters:

  AAAAAAAA,AAAAAAAA,AAAAAAAA,AAAAAAAA,AAAAAAAA,AAAAAAAA,...

Deprecating the mask in favor of the list on account of the
mask not fitting makes little sense to me, because worst case,
the list is even bigger ;).

Granted, the above examples consider the extreme case of
NR_CPUS == 65536 or some such.  But, as Mike notes, NR_CPUS
of 16384 might be needed; and the above quandry still applies
in that case.

Hmmm ... there are even more pathological list cases.  Take two
out of every three (drop those congruent to 0 mod 3):

  1,2,4,5,7,8,10,11,13,14,...,65521,65522,65524,65525,65527,65528,65530,65531,65533,65534

This requires 254736 characters ;).

Even for less insane values, of say two out of three CPUs when
NR_CPUS == 4096, it takes 12912 characters:

  1,2,4,5,7,8,10,11,13,14,...,4082,4084,4085,4087,4088,4090,4091,4093,4094

Whereas the mask format for 4096 NR_CPUS takes just 1152 characters.

On a system with 4K page size, the above two out of three list would
not actually show as that 12912 character string.  With the current
code, it would show as a 4094 character string, plus the trailing
newline and nul char, ending with (if I did my math right):

  ,1436,1438,1439,1441,1442,1444,1445,1447,1448,14

This is obviously not perfect from an ideal perspective.

However, I can't see that these pathological cases are enough of a
practical problem that we should actually spend code addressing them
at present.

On the other hand, and my main point of this message, I can't
see deprecating the mask format files on account of this sort
of analysis.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
