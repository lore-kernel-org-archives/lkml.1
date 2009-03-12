Return-Path: <linux-kernel-owner+w=401wt.eu-S1755743AbZCLDep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743AbZCLDep (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 23:34:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751614AbZCLDeg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 23:34:36 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:42187 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbZCLDef convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 23:34:35 -0400
Message-ID: <49B88280.8060603@cosmosbay.com>
Date: Thu, 12 Mar 2009 04:33:20 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Benjamin LaHaise <bcrl@kvack.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Jeff Moyer <jmoyer@redhat.com>,
       Avi Kivity <avi@redhat.com>, linux-aio <linux-aio@kvack.org>,
       zach.brown@oracle.com, linux-kernel@vger.kernel.org,
       Davide Libenzi <davidel@xmailserver.org>
Subject: Re: [patch] aio: remove aio-max-nr and instead use the memlock rlimit
 to limit the number of pages pinned for the aio completion ring
References: <x49bpsaelwa.fsf@segfault.boston.devel.redhat.com> <49B54143.1010607@redhat.com> <x49sklmd1fo.fsf@segfault.boston.devel.redhat.com> <49B57CB0.5020300@cosmosbay.com> <49B875F7.3030305@cosmosbay.com> <20090312024419.GG18665@kvack.org> <49B8807A.5080302@cosmosbay.com> <20090312032928.GH18665@kvack.org>
In-Reply-To: <20090312032928.GH18665@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Thu, 12 Mar 2009 04:33:21 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin LaHaise a écrit :
> On Thu, Mar 12, 2009 at 04:24:42AM +0100, Eric Dumazet wrote:
>>         if (!IS_ERR(req->ki_eventfd))
>>                 fput(req->ki_eventfd);   /* BANG : can be called from interrupt context */
> ...
>> Thank you
> 
> That's a bug in the eventfd code, not aio.  Davide: please fix.
> 

Hmm... what about fget_light() ... is it Davide fault too ?

aio breaks the fget_light() concept too, if process is mono threaded.

/*
 * Lightweight file lookup - no refcnt increment if fd table isn't shared.
 * You can use this only if it is guranteed that the current task already
 * holds a refcnt to that file. That check has to be done at fget() only
 * and a flag is returned to be passed to the corresponding fput_light().
 * There must not be a cloning between an fget_light/fput_light pair.
 */
struct file *fget_light(unsigned int fd, int *fput_needed)
{
        struct file *file;
        struct files_struct *files = current->files;

        *fput_needed = 0;
        if (likely((atomic_read(&files->count) == 1))) {
                file = fcheck_files(files, fd);
        } else {
                rcu_read_lock();
                file = fcheck_files(files, fd);
                if (file) {
                        if (atomic_long_inc_not_zero(&file->f_count))
                                *fput_needed = 1;
                        else
                                /* Didn't get the reference, someone's freed */
                                file = NULL;
                }
                rcu_read_unlock();
        }

        return file;
}



