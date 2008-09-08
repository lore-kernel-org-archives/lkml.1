Return-Path: <linux-kernel-owner+w=401wt.eu-S1755455AbYIHWGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455AbYIHWGj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 18:06:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752171AbYIHWG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 18:06:29 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:24117 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755209AbYIHWG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 18:06:28 -0400
Date: Mon, 8 Sep 2008 15:04:56 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Elias Oltmanns <eo@nebensachen.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] Add documentation for hard disk shock protection
 interface
Message-Id: <20080908150456.5069a551.randy.dunlap@oracle.com>
In-Reply-To: <20080829211345.4355.5630.stgit@denkblock.local>
References: <87wshzplvk.fsf@denkblock.local>
	<20080829211345.4355.5630.stgit@denkblock.local>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Aug 2008 23:28:41 +0200 Elias Oltmanns wrote:

> Put some information (and pointers to more) into the kernel's doc tree,
> describing briefly the interface to the kernel's disk head unloading
> facility. Information about how to set up a complete shock protection
> system under GNU/Linux can be found on the web and is referenced
> accordingly.
> 
> Signed-off-by: Elias Oltmanns <eo@nebensachen.de>
> ---
> 
>  Documentation/laptops/disk-shock-protection.txt |  131 +++++++++++++++++++++++
>  1 files changed, 131 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/laptops/disk-shock-protection.txt
> 
> diff --git a/Documentation/laptops/disk-shock-protection.txt b/Documentation/laptops/disk-shock-protection.txt
> new file mode 100644
> index 0000000..bd483a3
> --- /dev/null
> +++ b/Documentation/laptops/disk-shock-protection.txt
> @@ -0,0 +1,131 @@
> +Hard disk shock protection
> +==========================
> +
> +Author: Elias Oltmanns <eo@nebensachen.de>
> +Last modified: 2008-08-28
> +
> +
> +0. Contents
> +-----------
> +
> +1. Intro
> +2. The interface
> +3. References
> +4. CREDITS
> +
> +
> +1. Intro
> +--------
> +
> +ATA/ATAPI-7 specifies the IDLE IMMEDIATE command with unload feature.
> +Issuing this command should cause the drive to switch to idle mode and
> +unload disk heads. This feature is being used in modern laptops in
> +conjunction with accelerometers and appropriate software to implement
> +a shock protection facility. The idea is to stop all I/O operations on
> +the internal hard drive and park its heads on the ramp when critical
> +situations are anticipated. The desire to have such a feature
> +available on GNU/Linux systems has been the original motivation to
> +implement a generic disk head parking interface in the Linux kernel.
> +Please note, however, that other components have to be set up on your
> +system in order to get disk shock protection working (see section
> +3. Referneces below for pointers to more information about that).

      References

> +
> +
> +2. The interface
> +----------------
> +
> +The interface works as follows: Writing an integer value to
> +/sys/block/*/device/unload_heads will take the heads of the respective
> +drive off the platter and block all I/O operations for the specified
> +number of seconds. When the timeout expires and no further disk head
> +park request has been issued in the meantime, normal operation will be
> +resumed. The maximal value accepted for a timeout is 30 seconds.
> +However, you can always reset a running timer to any value between 0
> +and 30 by issuing a subsequent head park request before the timer of
> +the previous one has expired. In particular, the total timeout can
> +exceed 30 seconds and, more importantly, you can abort a timer and
> +resume normal operation immediately by specifying a timeout of 0.
> +Reading from /sys/block/*/device/unload_heads will report zero if no
> +timer is running and the number of seconds until the timer expires
> +otherwise.
> +
> +There is a technical detail of this implementation that may cause some
> +confusion and should be discussed here. When a head park request has
> +been issued to a device successfully, all I/O operations on the
> +controller port this device is attached to will be deferred. That is
> +to say, any other device that may be connected to the same port will
> +be affected too. For that reason, head parking requests will be sent
> +to all devices that support this feature sharing the same port before
> +that port is taken offline, as it were. As far as PATA (old style IDE)
> +configurations are concerned, there can only be two devices attached
> +to any single port. In SATA world we have port multipliers which means
> +that a user issued head parking request to one device may actually
> +result in stopping I/O to a whole bunch of deviices. Hwoever, since

                                              devices.  However,

> +this feature is supposed to be used on laptops and does not seem to be
> +very useful in any other environment, there will be mostly one device
> +per port. Even if the CD/DVD writer happens to be connected to the
> +same port as the hard drive, it generally *should* recover just fine
> +from the occasional buffer under-run incurred by a head park request
> +to the HD.
> +
> +Write access to /sys/block/*/device/unload_heads is denied with
> +-EOPNOTSUPP if the device does not support the unload feature. Read
> +access, on the other hand, is granted on all devices, so it is easy to
> +find out whether two devices share the same port and are subject to
> +the limitation described in the previous paragraph. Just do, for
> +example:
> +
> +# echo 30 > /sys/block/sda/device/unload_heads
> +
> +and check whether
> +
> +# cat /sys/block/device/sdb/unload_heads
> +
> +gives you a nonzero value (assuming, of course, there actually are

I prefer:      non-zero

> +devices sda and sdb up and running in your system).
> +
> +Finally, there are some hard drives that only comply with an earlier
> +version of the ATA standard than ATA-7, but do support the unload
> +feature nonetheless. Unfortunately, there is no safe way Linux can
> +detect these devices, so you won't be able to write to the
> +unload_heads attribute. If you know that your device really does
> +support the unload feature (for instance, because the vendor of your
> +laptop or the hard drive itself told you so), the you can tell the
> +kernel to enable the usage of this feature for that drive by means of
> +the unload_feature attribute:
> +
> +# echo 1 > /sys/block/*/device/unload_feature
> +
> +will enable the feature on that particular device, and giving 0
> +instead of 1 will disable it again.
> +
> +
> +3. References
> +-------------
> +
> +There are several laptops from different brands featuring shock

                                            vendors

> +protection capabilities. As manufacturers have refused to support open
> +source development of the required software components so far, Linux
> +support for shock protection varies considerably between different
> +hardware implementations. Ideally, this section should contain a list
> +of pointers at different projects aiming at an implementation of shock
> +protection on different systeems. Unfortunately, I only know of a
> +single project which, although still considered experimental, is fit
> +for use. Please feel free to add projects that have been the victims
> +of my ignorance.
> +
> +- http://www.thinkwiki.org/wiki/HDAPS
> +  See this page for information about Linux support of the hard disk
> +  active protection system as implemented in IBM/Lenovo Thinkpads.
> +  (FIXME: The information there will have to be updated once this
> +  patch has been approved or the user interface has been agreed upon
> +  at least.)
> +
> +
> +4. CREDITS
> +----------
> +
> +This implementation of disk head parking has been based on a patch
> +originally published by Jon Escombe <lists@dresco.co.uk>. Assisted by
> +various kernel developers, the author of this document has rewritten
> +the original patch in order to make it fit for upstream submission.

---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
