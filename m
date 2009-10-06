Return-Path: <linux-kernel-owner+w=401wt.eu-S1756436AbZJFI2M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756436AbZJFI2M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 04:28:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756327AbZJFI2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 04:28:11 -0400
Received: from smtp.ispras.ru ([83.149.198.201]:34612 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756033AbZJFI2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 04:28:09 -0400
From: iceberg <strakh@ispras.ru>
Organization: ISP RAS
To: James Bottomley <James.Bottomley@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, eric@andante.org,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] scsi_lib.c: sleeping function called from invalid context
Date: Tue, 6 Oct 2009 12:30:02 +0000
User-Agent: KMail/1.10.3 (Linux/2.6.27.29-0.1-default; KDE/4.1.3; x86_64; ; )
References: <200909231758.47612.strakh@ispras.ru> <200910051835.51891.strakh@ispras.ru> <1254755602.3838.5.camel@mulgrave.site>
In-Reply-To: <1254755602.3838.5.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910061230.03488.strakh@ispras.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 October 2009 15:13:22 you wrote:
> > > Hang on ... I looked at the bug report again: there's no actual kernel
> > > trace, just a theoretical function graph.
> > >
> > > Has this actually been seen or is it just the result of an analysis?
> > >
> > > If the latter (which I suspect), there's no actual problem.  The
> > > explicit design of the calls is that device_initialize() and
> > > put_device() can be called from interrupt context.  device_add() and
> > > device_del() must be called from user context.
> > >
> > > The path you seem to be showing is the put_device() path where there's
> > > been an error in the state model and the caller is doing last put on a
> > > visible device without having first called device_del().
> > >
> > > If you see the real kernel message about this, it means there's a bug
> > > in the device model handling somewhere in SCSI.  If you haven't seen
> > > the message, it's just a bug in the static analysis tool.
> >
> > This bug report is the result of code inspection. I'm considering
> > functions which can call might_sleep macro and consequently which can not
> > be called from atomic context.
> > I choose function scsi_device_put. There are two paths to might_sleep
> > macro. First path was shown in the report, second is:
> > 1. scsi_device_put calls put_device at ./drivers/scsi/scsi.c:1111
> > 2. put_device calls kobject_put at ./drivers/base/core.c:1038
> > 3. kobject_put calls kref_put at ./lib/kobject.c
> > 4. kref_put may call callback function kobject_release at ./lib/kref.c if
> > refcount becomes zero
> > 5. kobject_cleanup calls kobject_del at ./lib/kobject.c:562
>
> only if state_in_sysfs is set.
>
> This is only set if the caller previously failed to call kobject_del
> (i.e. device_del).
>
> As long as devices follow the proper create->add->del->put paths, the
> final put may be called from interrupt context.
>
> Your analysis is wrong because you're basing it on the exception cleanup
> paths not the correct calling paths.
>
> James
>
> > 6. kobject_del calls sysfs_remove_dir at ./lib/kobject.c:516
> > 7. sysfs_remove_dir calls __sysfs_remove_dir at ./fs/sysfs/dir.c:821
> > 8. __sysfs_remove_dir calls sysfs_addrm_start at ./fs/sysfs/dir.c:789
> > 9. sysfs_addrm_start calls mutex_lock at ./fs/sysfs/dir.c:377, which
> > might_sleep because it calls might_sleep macro.
> >
> > As you wrote earlier, scsi_device_put was designed with the ability to
> > call last put from interrupt context, but as we can see from the paths
> > there might be situations where it is not true. Moreover, while analysing
> > different usage patterns of scsi_device_put, I found that people are
> > using scsi_device_put as if it can not be called from atomic context.
> > Because before calling scsi_device_put, spin_locks are always released
> > (i.e. spin_unlock is called before scsi_device_put and spin_lock is
> > called after it). Examples are: 1. drivers/scsi/dpt_i2o.c line 701
> > 2. drivers/ata/libata-scsi.c line 3626
> > 3. drivers/scsi/ipr.c line 2415
> >
> > >The path you seem to be showing is the put_device() path where there's
> > >been an error in the state model and the caller is doing last put on a
> > >visible device without having first called device_del().
> >
> > In scsi_lib.c  prior to scsi_device_put we always do scsi_device_get.  As
> > far as I understand, if we are sure that scsi_device_put is always not
> > last, then we can remove both calls to scsi_device_get and to
> > scsi_device_put from the code without introducing races.
> >
> >  347         list_for_each_entry_safe(sdev, tmp, &starget->devices,
> >  348                         same_target_siblings) {
> >  349                 if (sdev == current_sdev)
> >  350                         continue;
> >  351                 if (scsi_device_get(sdev))
> >  352                         continue;
> >  353
> >  354                 spin_unlock_irqrestore(shost->host_lock, flags);
> >  355                 blk_run_queue(sdev->request_queue);
> >  356                 spin_lock_irqsave(shost->host_lock, flags);
> >  357
> >  358                 scsi_device_put(sdev);
> >  359         }
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

James, what about code where spin_unlock is called before scsi_device_put, 
especially for avoiding atomic context?
In code like 
	spin_unlock
	scsi_device_put
	spin_lock
Is spin_unlock/spin_lock redundant?

Why do we need scsi_device_get/scsi_device_put pair in scsi_lib.c at all? If 
we are sure that scsi_device_put is always not last, for what purpose do we 
call it together with scsi_device_get in the loop?





