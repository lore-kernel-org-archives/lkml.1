Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357Ab0BKNpU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 08:45:20 -0500
Received: from mail-bw0-f219.google.com ([209.85.218.219]:59406 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967Ab0BKNpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 08:45:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=ZdyWb5RfLN6F5Q/qN4qJy2+UPN6hLUJReGCKPY0NoPLWkwAvCXbnBnD8Z+ycKsoZYm
         uYkb7/alNwKXdNqb/yQQXgJ0GAGiTO2Mr5UYtzdRqMRR6qUD+r0wP1DcO06w5B1+Vgyp
         FW4KzRXbfhYpfSa3L0CwJN7iFppApArvCyNPU=
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Subject: Re: [PATCH 1/4] block: implement compatible DISCARD support
References: <1265885625-21608-1-git-send-email-dmonakhov@openvz.org>
	<20100211122154.GA12417@infradead.org> <87d40cq66k.fsf@openvz.org>
	<20100211130945.GA7644@infradead.org>
Date: Thu, 11 Feb 2010 16:45:13 +0300
In-Reply-To: <20100211130945.GA7644@infradead.org> (Christoph Hellwig's
	message of "Thu, 11 Feb 2010 08:09:45 -0500")
Message-ID: <87tytnga3a.fsf@openvz.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@infradead.org> writes:

> On Thu, Feb 11, 2010 at 03:59:31PM +0300, Dmitry Monakhov wrote:
>> I mean that it is impossible to know was it really successful or not.
>> We may just replace this function with this following function.
>> const char* make_me_hapy()
>> {
>>    return "you are happy already.";
>> }
>
> Which is an entirely valid, although suboptimal implementation.
>
>> AFAIK Currently there is no any generic block interface which send
>> io requests without ability to check the result. 
>> The question is should it be sync or async it is not easy to design
>> simple async interface so let's use sync by default
>> BTW: That's why blkdev_issue_barrier has to wait by default. 
In fact wait is the only interface for issue_barrier.
> This is going to kill performance.
But it may be reasonable to allow caller to choose would it
wait and work fair, or to cheat in a name of performance.
>
>> > That's incorrect - both the scsi WRITE SAME and ATA UNMAP
>> > implementations write to the payload. 
>> WOW. What for?
>
> Becuase these commands contain ranges of to be flushed blocks
> in their payload.
Ok i've found. 
libata-scsi.c: ata_scsi_write_same_xlat
                  ata_set_lba_range_entries
It's was not obvious from the first glance. But it is the way how it
works for now. But seems what we still optimize things a bit
1) alloc page with GFP_HIGHUSER (because x86 arch still used)
2) Share page between eight bios.
>
>> > Which is a bit different from fixing efficiency issues in discard, I'd
>> > prefer that to be split into a separate patch, especially as there might
>> > be quite a bit of discussion on the zeroout behaviour.
>> Seems that you also right here. At list it is not obvious how we should
>> send compat_discard bios WRITE,WRITE_SYNC or WRITE_SYNC_PLUG?
>> But blkdev_issue_zeroout() interface allow all this flags.
>> let's wait a bit and i'll redesign the patchset correspondingly
>
> The !wait case is ansynchronous, so WRITE seems fine.  The wait and
> !barrier case is more interesting, as this one is very close to
> synchrous write semantics.  But I'm not sure it's really worth
> optimization for that, this case is not used for online discarding
> but things like mkfs that have the filesystem for itself, or that
> not yet merged background discard for xfs which doesn't care too
> much about I/O priority.
