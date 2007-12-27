Return-Path: <linux-kernel-owner+w=401wt.eu-S1752649AbXL0ObB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649AbXL0ObB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 09:31:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751901AbXL0Oaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 09:30:52 -0500
Received: from py-out-1112.google.com ([64.233.166.177]:7743 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871AbXL0Oav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 09:30:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QFypQe1avVTfp/D6Wjvq/uUzmqZtTEPeZx7F1cMYrsDk0KBqiw9pFCXC+ChMTuOu1kf5IKE+WbYT6J9TaotI8KGWREajZVLeKmUEvZisFSihXB0U3BbYhpfl9eO4cmWmQ/BYJVDf+VcBkHVMxMR9ToiJZCXZIpT7LxPNwbVUXBY=
Message-ID: <64bb37e0712270630x65ae1da0l3316aca9327d3b6b@mail.gmail.com>
Date: Thu, 27 Dec 2007 15:30:50 +0100
From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.24-rc6-mm1
Cc: linux-kernel@vger.kernel.org, "Alasdair G Kergon" <agk@redhat.com>,
       "Greg KH" <greg@kroah.com>, NeilBrown <neilb@suse.de>
In-Reply-To: <64bb37e0712270342v751e9a63n20da68a621c07647@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071222233056.d652743e.akpm@linux-foundation.org>
	 <64bb37e0712230827m7d368e2l3174f3b4396d09c1@mail.gmail.com>
	 <20071223123930.27f46d24.akpm@linux-foundation.org>
	 <64bb37e0712270342v751e9a63n20da68a621c07647@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[author CCed]
On Dec 27, 2007 12:42 PM, Torsten Kaiser <just.for.lkml@googlemail.com> wrote:
> On Dec 23, 2007 9:39 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > On Sun, 23 Dec 2007 17:27:12 +0100 "Torsten Kaiser" <just.for.lkml@googlemail.com> wrote:
> >
> > > On Dec 23, 2007 8:30 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> > > >
> > > > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc6/2.6.24-rc6-mm1/
> > > [snip]
> > > > +md-allow-devices-to-be-shared-between-md-arrays.patch
[snip]
> OK, I debugged this some more. It looks like two bugs meshed together.
>
> One new bug: "do_md_run() returned -22"
> I can't seem to start my raid anymore.
> The following part of md-allow-devices-to-be-shared-between-md-arrays
> adds a new check to do_md_run() (drivers/md/md.c) that fails for my system:
> @@ -3213,8 +3283,11 @@ static int do_md_run(mddev_t * mddev)
>         /*
>          * Analyze all RAID superblock(s)
>          */
> -       if (!mddev->raid_disks)
> +       if (!mddev->raid_disks) {
> +               if (!mddev->persistent)
> +                       return -EINVAL;
>                 analyze_sbs(mddev);
> +       }
>
>         chunk_size = mddev->chunk_size;

This hunk is indeed buggy.
analyze_sbs() calls load_super() and validate_super() and only the
validate function is setting mddev->persistent, so this new check
needs to be after the call analyze_sbs(mddev).

Changing this allows my system to boot correctly, including starting KDE.

Please note, that this is not a fix for the OOPS in delayed_delete,
the OOPS just doesn't happen, because the buggy error path is no
longer used.

Torsten
