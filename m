Return-Path: <linux-kernel-owner+w=401wt.eu-S1754719AbYBXXXK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719AbYBXXXK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 18:23:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750787AbYBXXW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 18:22:58 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:59830 "EHLO
	outbound9-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750758AbYBXXW5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 18:22:57 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 149.199.60.83;Service: EHS
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] Xilinx: hwicap: cleanup
Date: Sun, 24 Feb 2008 15:21:49 -0800
In-Reply-To: <fa686aa40802232216s47b7751bi384352697dbf4ce2@mail.gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] Xilinx: hwicap: cleanup
Thread-Index: Ach2rOAeMIJkJhu0SAKGG/nJr27q4QAh2cYg
References: <1202437061-12691-1-git-send-email-stephen.neuendorffer@xilinx.com> <20080211182429.76E204D8018@mail62-sin.bigfish.com> <fa686aa40802232216s47b7751bi384352697dbf4ce2@mail.gmail.com>
From: "Stephen Neuendorffer" <stephen.neuendorffer@xilinx.com>
To: "Grant Likely" <grant.likely@secretlab.ca>
Cc: <linuxppc-dev@ozlabs.org>, "git-dev" <git-dev@xilinx.com>,
       <jirislaby@gmail.com>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 24 Feb 2008 23:21:52.0053 (UTC) FILETIME=[0975FE50:01C8773C]
Message-Id: <20080224232152.CEC5F12C8057@mail99-dub.bigfish.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: glikely@secretlab.ca [mailto:glikely@secretlab.ca] On Behalf Of
Grant Likely
> Sent: Saturday, February 23, 2008 10:17 PM
> To: Stephen Neuendorffer
> Cc: linuxppc-dev@ozlabs.org; git-dev; jirislaby@gmail.com;
linux.kernel@vger.kernel.org
> Subject: Re: [PATCH] Xilinx: hwicap: cleanup
> 
> On Mon, Feb 11, 2008 at 11:24 AM, Stephen Neuendorffer
> <stephen.neuendorffer@xilinx.com> wrote:
> > Fix some missing __user tags and incorrect section tags.
> >  Convert semaphores to mutexes.
> >  Make probed_devices re-entrancy and error condition safe.
> >  Fix some backwards memcpys.
> >  Some other minor cleanups.
> >  Use kerneldoc format.
> >
> >  Signed-off-by: Stephen Neuendorffer
<stephen.neuendorffer@xilinx.com>
> 
> Thanks Steven, some more comments below.
> 
> >
> >  ---
> >
> >  Grant, Since it appears that the driver will stay in as-is, here
are
> >  the updates against mainline, based on Jiri's comments.
> >  ---
> >   drivers/char/xilinx_hwicap/buffer_icap.c   |   80
++++++++++----------
> >   drivers/char/xilinx_hwicap/fifo_icap.c     |   60 +++++++-------
> >   drivers/char/xilinx_hwicap/xilinx_hwicap.c |  113
++++++++++++++++------------
> >   drivers/char/xilinx_hwicap/xilinx_hwicap.h |   24 +++---
> >   4 files changed, 148 insertions(+), 129 deletions(-)
> >
> >  diff --git a/drivers/char/xilinx_hwicap/buffer_icap.c
b/drivers/char/xilinx_hwicap/buffer_icap.c
> >  index dfea2bd..2c5d17d 100644
> >  --- a/drivers/char/xilinx_hwicap/buffer_icap.c
> >  +++ b/drivers/char/xilinx_hwicap/buffer_icap.c
> >  @@ -148,9 +148,9 @@ static inline void buffer_icap_set_size(void
__iomem *base_address,
> >   }
> >
> >   /**
> >  - * buffer_icap_mSetoffsetReg: Set the bram offset register.
> >  - * @parameter base_address: contains the base address of the
device.
> >  - * @parameter data: is the value to be written to the data
register.
> >  + * buffer_icap_mSetoffsetReg - Set the bram offset register.
> 
> This is the only function that is still in camel case; it should
> probably be changed also... In fact, this functions doesn't seem to be
> used at all.  Can it just be removed?  Are there any other unused
> functions in this driver?

Actually, it's just the comment that still had the old name.. Fixed it.

-Wall reports one unused static:

drivers/char/xilinx_hwicap/xilinx_hwicap.c:240: warning:
'hwicap_command_capture' defined but not used

I'd intended to leave this in, but I'm thinking it can be done by
userspace code using this driver, so I took it out too.

In verifying this, I discovered that I had inserted a variable names
'register', which doesn't work...  Fixed that too.

> >  diff --git a/drivers/char/xilinx_hwicap/xilinx_hwicap.c
> b/drivers/char/xilinx_hwicap/xilinx_hwicap.c
> >  index 24f6aef..eddaa26 100644
> >  --- a/drivers/char/xilinx_hwicap/xilinx_hwicap.c
> >  +++ b/drivers/char/xilinx_hwicap/xilinx_hwicap.c
> >  @@ -344,7 +345,7 @@ int hwicap_initialize_hwicap(struct
hwicap_drvdata *drvdata)
> >   }
> >
> >   static ssize_t
> >  -hwicap_read(struct file *file, char *buf, size_t count, loff_t
*ppos)
> >  +hwicap_read(struct file *file, __user char *buf, size_t count,
loff_t *ppos)
> 
> This looks like it should be 'char __user *buf' instead of '__user
char *buf'.

Fixed.
 
> >   {
> >         struct hwicap_drvdata *drvdata = file->private_data;
> >         ssize_t bytes_to_read = 0;
> >   static ssize_t
> >  -hwicap_write(struct file *file, const char *buf,
> >  +hwicap_write(struct file *file, const __user char *buf,
> >                 size_t count, loff_t *ppos)
> 
> Ditto on placement of __user

Fixed.

> 
> >  @@ -549,8 +556,7 @@ static int hwicap_release(struct inode *inode,
struct file *file)
> >         int i;
> >         int status = 0;
> >
> >  -       if (down_interruptible(&drvdata->sem))
> >  -               return -ERESTARTSYS;
> >  +       mutex_lock(&drvdata->sem);
> 
> Why not mutex_lock_interruptible()? (goes for all cases of
mutex_lock())

It's not clear to me how to get 'correct' behavior in these functions if
the interrupt happens.  For instance in probe/setup, if the mutex_lock
is interrupted, it doesn't appear that there is anything to do other
than return an error code that no device is present?  I think this was
suggested by Jiri...

Steve

