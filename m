Return-Path: <linux-kernel-owner+w=401wt.eu-S1752209AbZIOWMH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209AbZIOWMH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 18:12:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751840AbZIOWMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 18:12:06 -0400
Received: from mail-vw0-f195.google.com ([209.85.212.195]:58918 "EHLO
	mail-vw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824AbZIOWMF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 18:12:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ZHAQ0X+wFWbKwyfVNIb3VBNMkctY7ACOSFQs11rItB+4M4WU/nnS7rXXCyueuuEHWQ
         mm8qeGCmcwhGbcQKyviCvyFbDF4w/OU9tdlaPj5rzPFkLJewN5NMkhtfyF9Qp6dx7O5C
         xByr91mVaHNuAw1wAaedbBetscS9GGciCGIQU=
MIME-Version: 1.0
In-Reply-To: <19066.28054.65288.171564@notabene.brown>
References: <20090804141425.GA2831@redhat.com>
	 <58e2e493d0855face4e7d3fbf7ee65b9.squirrel@neil.brown.name>
	 <20090804212404.GA26390@suse.de>
	 <19066.28054.65288.171564@notabene.brown>
Date: Tue, 15 Sep 2009 15:12:07 -0700
X-Google-Sender-Auth: 496225464c36a5df
Message-ID: <e9c3a7c20909151512y48d066a9m71d4bb92e34b5294@mail.gmail.com>
Subject: Re: 2.6.31rc5 RAID10 lockdep report - sysfs_nofity_dirent locking 
	issue
From: Dan Williams <dan.j.williams@intel.com>
To: Greg KH <gregkh@suse.de>
Cc: Neil Brown <neilb@suse.de>, Dave Jones <davej@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Hans de Goede <hdegoede@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 5, 2009 at 10:43 PM, Neil Brown <neilb@suse.de> wrote:
> On Tuesday August 4, gregkh@suse.de wrote:
>> >
>> > Greg: does that look right?  If so I'll add a changelog entry and
>> > submit it properly (after at least a compile test...)
>>
>> Yes, it looks correct, if it passes your tests :)
>
> Thanks.
> I've tested it and documented it now and so am happy to submit it.
> Thanks,
> NeilBrown
>
>
> From: NeilBrown <neilb@suse.de>
> Date: Thu, 6 Aug 2009 15:42:08 +1000
> Subject: [PATCH] Allow sysfs_notify_dirent to be called from interrupt context.
>
> sysfs_notify_dirent is a simple atomic operation that can be used to
> alert user-space that new data can be read from a sysfs attribute.
>
> Unfortunately is cannot currently be called from non-process context
> because of it's use of spin_lock which is sometimes taken with
> interrupt enabled.
>
> So change all lockers of sysfs_open_dirent_lock to disable interrupts,
> thus making sysfs_notify_dirent safe to be called from non-process
> context (as drivers/md does in md_safemode_timeout).
>
> sysfs_get_open_dirent is (documented as being) only called from
> process context, so it uses spin_lock_irq.  Other places
> use spin_lock_irqsave.
>
> The usage for sysfs_notify_dirent in md_safemode_timeout was
> introduced in 2.6.28, so this patch is suitable for that and more
> recent kernels.
>
> Cc: stable@kernel.org
> Signed-off-by: NeilBrown <neilb@suse.de>
> ---

Greg?

Looks like this never made it upstream, and now Hans is hitting this
in his tests.

Thanks,
Dan
