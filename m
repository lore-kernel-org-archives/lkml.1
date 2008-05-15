Return-Path: <linux-kernel-owner+w=401wt.eu-S1756910AbYEOTGB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910AbYEOTGB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 15:06:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751300AbYEOTFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 15:05:53 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39662 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751248AbYEOTFw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 15:05:52 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [PATCH -mm] kexec jump -v9
Date: Thu, 15 May 2008 21:05:47 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
References: <1204773188.4707.109.camel@caritas-dev.intel.com> <m13aok1pt1.fsf@frodo.ebiederm.org> <1210815739.23707.74.camel@caritas-dev.intel.com>
In-Reply-To: <1210815739.23707.74.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805152105.48820.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 15 of May 2008, Huang, Ying wrote:
> On Wed, 2008-05-14 at 15:30 -0700, Eric W. Biederman wrote:
> [...]
> > >  
> > > +	if (image->preserve_context) {
> > > +		KJUMP_MAGIC(control_page) = KJUMP_MAGIC_NUMBER;
> > > +		if (kexec_jump_save_cpu(control_page)) {
> > > +			image->start = KJUMP_ENTRY(control_page);
> > > +			return;
> > 
> > Tricky, and I expect unnecessary.
> > We should be able to just have relocate_new_kernel return?
> 
> OK, I will check this. Maybe we can move CPU state saving code into
> relocate_new_kernel.
> 
> [...]
> > > -static void kernel_kexec(void)
> > > +static int kernel_kexec(void)
> > >  {
> > > +	int ret = -ENOSYS;
> > >  #ifdef CONFIG_KEXEC
> > > -	struct kimage *image;
> > > -	image = xchg(&kexec_image, NULL);
> > > -	if (!image)
> > > -		return;
> > > -	kernel_restart_prepare(NULL);
> > > -	printk(KERN_EMERG "Starting new kernel\n");
> > > -	machine_shutdown();
> > > -	machine_kexec(image);
> > > +	if (xchg(&kexec_lock, 1))
> > > +		return -EBUSY;
> > > +	if (!kexec_image) {
> > > +		ret = -EINVAL;
> > > +		goto unlock;
> > > +	}
> > > +	if (!kexec_image->preserve_context) {
> > > +		kernel_restart_prepare(NULL);
> > > +		printk(KERN_EMERG "Starting new kernel\n");
> > > +		machine_shutdown();
> > > +	}
> > > +	ret = kexec_jump(kexec_image);
> > > +unlock:
> > > +	xchg(&kexec_lock, 0);
> > >  #endif
> > 
> > Ugh.  No.  Not sharing the shutdown methods with reboot and
> > the normal kexec path looks like a recipe for failure to me.
> > 
> > This looks like where we really need to have the conversation.
> > What methods do we use to shutdown the system.
> > 
> > My take on the situation is this.  For proper handling we
> > need driver device_detach and device_reattach methods.
> > 
> > With the following semantics.  The device_detach methods
> > will disable DMA and place the hardware in a sane state
> > from which the device driver can reclaim and reinitialize it,
> > but the hardware will not be touched.
> > 
> > device_reattach reattaches the driver to the hardware.
> 
> Yes. Current device PM callback is not suitable for hibernation (kexec
> based or original). I think we can collaborate with Rafael J. Wysocki on
> the new device drivers hibernation callbacks.

Thanks, I'm also open for collaboration.  There will be a lot of work to do
related to the new callbacks, so any contribution is certainly welcome.

Thanks,
Rafael
