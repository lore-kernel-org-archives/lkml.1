Return-Path: <linux-kernel-owner+w=401wt.eu-S1754576AbYA0CxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576AbYA0CxW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 21:53:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752664AbYA0CxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 21:53:12 -0500
Received: from qb-out-0506.google.com ([72.14.204.235]:55873 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbYA0CxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 21:53:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=vLoltlyrl69M+8SETVJzyxmq23r4INx601bHd/cev/R59sUVRj07yK2EpJqHf8FmYIQUlF4CHH6OCQgKhSkF04JnpxAR2sp93QhGBTNE2ZIrehNv8Nw7yqYuXYD+1hCoY1I8eBU4Lk047DCoIVHn/taOpYM0uSETUMNJAvSPw9A=
Date: Sun, 27 Jan 2008 10:50:51 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Jeff Garzik <jeff@garzik.org>, WANG Cong <xiyou.wangcong@gmail.com>,
       Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [Patch] Shut up warnings from files under drivers/
Message-ID: <20080127025051.GB2495@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20080126093007.GB20935@hacking> <479B03AE.3090600@garzik.org> <20080126191717.GA25701@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080126191717.GA25701@uranus.ravnborg.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 26, 2008 at 08:17:17PM +0100, Sam Ravnborg wrote:
>On Sat, Jan 26, 2008 at 04:55:58AM -0500, Jeff Garzik wrote:
>> WANG Cong wrote:
>> >diff --git a/drivers/video/kyro/fbdev.c b/drivers/video/kyro/fbdev.c
>> >index acb9370..437ebd0 100644
>> >--- a/drivers/video/kyro/fbdev.c
>> >+++ b/drivers/video/kyro/fbdev.c
>> >@@ -90,7 +90,9 @@ static int nomtrr __devinitdata = 0;
>> > 
>> > /* PCI driver prototypes */
>> > static int kyrofb_probe(struct pci_dev *pdev, const struct pci_device_id 
>> > *ent);
>> >+#if defined(MODULE) || defined(CONFIG_HOTPLUG)
>> > static void kyrofb_remove(struct pci_dev *pdev);
>> >+#endif
>> > 
>> > static struct fb_videomode kyro_modedb[] __devinitdata = {
>> > 	{
>> >@@ -754,6 +756,7 @@ out_unmap:
>> > 	return -EINVAL;
>> > }
>> > 
>> >+#if defined(MODULE) || defined(CONFIG_HOTPLUG)
>> > static void __devexit kyrofb_remove(struct pci_dev *pdev)
>> > {
>> > 	struct fb_info *info = pci_get_drvdata(pdev);
>> >@@ -783,6 +786,7 @@ static void __devexit kyrofb_remove(struct pci_dev 
>> >*pdev)
>> > 	pci_set_drvdata(pdev, NULL);
>> > 	framebuffer_release(info);
>> > }
>> >+#endif
>> 
>> 
>> Quite strange -- due to __devexit_p() and the __devexit marker, ifdefs 
>> should not be needed.
>> 
>> I would look into why that isn't working as designed in these cases...
>
>I checked up on the synclink.c warning.
>We have the following code:
>
>static void synclink_remove_one (struct pci_dev *dev);
>
>...
>
>static struct pci_driver synclink_pci_driver = {
>        .remove         = __devexit_p(synclink_remove_one),
>};
>
>...
>
>static void __devexit synclink_remove_one (struct pci_dev *dev)
>{
>}
>
>And I double checked the preprocessed source to check
>that we applied the __attribute__((__used__)) to the function.

Yes. The only macro we used on synclink_remove_one is __devexit.
It's defination is:

#ifdef CONFIG_HOTPLUG
#define __devexit
#else
#define __devexit __exit
#endif

And __exit is:
#ifdef MODULE
#define __exit          __attribute__ ((__section__(".exit.text"))) __cold
#else
#define __exit          __attribute_used__ __attribute__ ((__section__(".exit.text"))) __cold
#endif

So only when !defined(MODULE) && !defined(CONFIG_HOTPLUG),
__attribute_used__ is applied. And this case is just that
condition, thus this should be a bogus of gcc.


>
>Investigating a bit more I realized that gcc looses the
>__used__ attribution due to the prototype.
>So there are two correct fixes:
>a) move the function up so we do not need the forward
>   declaration
>b) add a __devexit to the forward decalration too.
>
>I strongly prefer the first version and this is the
>correct fix for these cases.
>
>Do we have a gcc bug here - I did not see a definitive answer in gcc docs?
>

Agreed. I will try a).


