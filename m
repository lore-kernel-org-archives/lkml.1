Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936403Ab0B1S4z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 13:56:55 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:43282 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935173Ab0B1S4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 13:56:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=StoRQERjuOxwNgHN5dZIFonQrW6bqf9YTBuaysn8tFt7sQR6B8gvgKnflECKzetubp
         9+bwJx1JxDb2xPyBpJQpO9mZDLbcoeSU6HbajV/e+8UHtl0rfAYLUGSxUboGhYO7I+ou
         jXhHs86hvjkV2Co0UvREHvcSTShkh11DEY9nA=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Robert Hancock <hancockrwd@gmail.com>
Subject: Re: [git patch] atang tree: make SATA Asynchronous Notification work
Date: Sun, 28 Feb 2010 19:55:47 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-0.1-desktop; KDE/4.3.5; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <201002281531.45149.bzolnier@gmail.com> <51f3faa71002280952p479dd795ue6a4e4a06b67e6f8@mail.gmail.com>
In-Reply-To: <51f3faa71002280952p479dd795ue6a4e4a06b67e6f8@mail.gmail.com>
MIME-Version: 1.0
Message-Id: <201002281955.47766.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 28 February 2010 06:52:23 pm Robert Hancock wrote:
> On Sun, Feb 28, 2010 at 8:31 AM, Bartlomiej Zolnierkiewicz
> <bzolnier@gmail.com> wrote:
> > DISCLAIMER: the fact of getting patches merged into atang tree means
> > that from now on they will be getting updates for changes happening
> > in atang tree and it should not be treated as an indication regarding
> > decisions taken by 'upstream' kernel trees
> >
> >
> > Fix Asynchronous Notification (AN) support for SATA ATAPI devices
> > (drives which support this feature will send a notification when new
> > media is inserted and removed, preventing the need for user space to
> > poll for new media needlessly consuming energy and CPU resources).
> >
> > Originally AN support was added to kernel in 2007, unfortunately some
> > relevant bits were lost in the merge process and the feature remains
> > non-functional in modern Linux distributions.  Lets fix it by adding
> > kernel patch by Robert Hancock (from Oct 2009) addressing the issue.
> >
> > User-space part (HAL daemon in particular) still won't automatically
> > disable media polling but it can be done manually by executing:
> >
> >  hal-disable-polling --device /dev/sr0
> >
> > command as root.
> >
> > [ To check if your ATAPI device supports AN:
> >  # hdparm -I /dev/sr0|grep "Asynchronous notification"
> >
> >  To check if it is properly recognized by kernel & user-space:
> >  $ lshal|grep support_async_notification ]
> >
> >
> > PS1 if you have PLDS DS-8A3S drive in your laptop (like me) you may
> > need to update the drive's firmware to the one containing AN support
> > (HA28 for Asus' OEM drives and HD52 for Dell's ones)
> >
> > PS2 I will be rebasing atang on top of 2.6.33 in the near future
> >
> >
> > The following changes since commit cad2f21db052f21beafd44d3396a565d9a485073:
> >  Bartlomiej Zolnierkiewicz (1):
> >        block: fix SSD performance regression
> >
> > are available in the git repository at:
> >
> >  git://git.kernel.org/pub/scm/linux/kernel/git/bart/misc.git atang-v4.9
> >
> > Robert Hancock (1):
> >      scsi: properly export media change notification capability in block device flags
> >
> >  drivers/scsi/sd.c |    2 ++
> >  drivers/scsi/sr.c |    2 ++
> >  2 files changed, 4 insertions(+), 0 deletions(-)
> 
> I think that patch is still applicable, but as you noted it doesn't
> really have much effect on HAL by itself other than reporting the
> "supports asynchronous notification" flag, there's nothing in HAL that
> automatically stops polling when that's detected (at least last I
> checked).

The real issue is that without the said flag being set media change
notification will stop working after you manually disable polling,
see the code in hald/linux/blockdev.c:

void
hotplug_event_refresh_blockdev (gchar *sysfs_path, HalDevice *d, void *end_token)
{
        HAL_INFO (("block_change: sysfs_path=%s", sysfs_path));

        if (hal_device_property_get_bool (d, "storage.removable.support_async_notification")) {
                blockdev_rescan_device (d);
        }

        /* done with change event */
        hotplug_event_end (end_token);
}

> As I recall the new HAL replacement (DeviceKit-disks I believe)
> doesn't depend on that particular flag to detect AN support.

Well, current distributions (i.e. openSUSE 11.2) still use HAL and I want
AN now, not in another 'x' years...  but I also took a look at udisks now
(which is a newer/re-branded DeviceKit-disks), src/device.c:

/* device_is_media_change_detected, device_is_media_change_detection_* properties */
static gboolean
update_info_media_detection (Device *device)
{
  gboolean detected;
  gboolean polling;
  gboolean inhibitable;
  gboolean inhibited;

  detected = FALSE;
  polling = FALSE;
  inhibitable = FALSE;
  inhibited = FALSE;

  if (device->priv->device_is_removable)
    {
      guint64 evt_media_change;
      GUdevDevice *parent;

      evt_media_change = sysfs_get_uint64 (device->priv->native_path, "../../evt_media_change");
      if (evt_media_change & 1)
        {
          /* SATA AN capabable drive */

          polling = FALSE;
          detected = TRUE;
          goto determined;
...

so DeviceKit should work fine but at the cost of relying on SCSI interfaces
instead of more generic block ones..

--
Bartlomiej Zolnierkiewicz
