Return-Path: <linux-kernel-owner+w=401wt.eu-S1752097AbZHSDH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097AbZHSDH1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 23:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751933AbZHSDH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 23:07:26 -0400
Received: from mail-px0-f182.google.com ([209.85.216.182]:56498 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbZHSDHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 23:07:25 -0400
X-Greylist: delayed 1920 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Aug 2009 23:07:25 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=UzIXCng9cPNFIP+niDHHCRA9r0AJz4x/a1T9QIFhD93h/eLlFHlZm2B8JCDhVUpqbA
         ko1XE2bdsf+1+x+u35zybkFeMTFqZgb/dvGWU1bOXVwP9/9SodBxOb08cvwMP0Pvq5+L
         ZOeXvSvDSRMtm1y5eU4+Paw1K5jl9d6wnaQuU=
Message-ID: <4A8B6C57.2080000@gmail.com>
Date: Wed, 19 Aug 2009 11:07:03 +0800
From: Eric Miao <eric.y.miao@gmail.com>
Reply-To: eric.y.miao@gmail.com
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: "Aric D. Blumer" <aric@sdgsystems.com>
CC: Greg KH <greg@kroah.com>, Eric Miao <eric.y.miao@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mike Rapoport <mike@compulab.co.il>,
       Russell King <rmk@arm.linux.org.uk>
Subject: Re: linux-next: usb/pxa trees build failure
References: <20090818135852.0b3b648d.sfr@canb.auug.org.au> <20090818114242.GA28534@kroah.com> <4A8AB525.7050404@gmail.com> <20090818145800.GB6074@kroah.com> <4A8B521D.8080901@sdgsystems.com>
In-Reply-To: <4A8B521D.8080901@sdgsystems.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aric D. Blumer wrote:
> Greg KH wrote:
>> On Tue, Aug 18, 2009 at 10:05:25PM +0800, Eric Miao wrote:
>>   
>>> Greg KH wrote:
>>>     
>>>> On Tue, Aug 18, 2009 at 01:58:52PM +1000, Stephen Rothwell wrote:
>>>>       
>>>>> Hi Eric, Greg,
>>>>>
>>>>> The next-20090817 (and a few before) build (arm trizeps4_defconfig)
>>>>> failed like this:
>>>>>
>>>>> drivers/usb/host/ohci-pxa27x.c:507: error: 'pdev' undeclared (first use in this function)
>>>>>
>>>>> Caused by the interaction of commit
>>>>> 6458baec17e19d38b9d4eb1f96c213f91609c0e3 ("USB: ohci-pxa27x: Reconfigure
>>>>> power settings on resume") from the usb tree with commit
>>>>> b8fb7d4317bcea1b48c9560d23dff81121870ece ("[ARM] pxa: update
>>>>> ohci-pxa27x.c to use 'struct dev_pm_ops'"). from the pxa tree.
>>>>>
>>>>> Greg/Aric, maybe that usb tree patch needs to go through the pxa tree?
>>>>> (and maybe "USB: ohci-pxa27x: Allow NOCP and OCPM to be cleared" as well?)
>>>>>
>>>>> [this also broke the following configs: magician_defconfig,
>>>>> em_x270_defconfig and cm_x2xx_defconfig.]
>>>>>         
>>>> Ick, not good.  Aric, should I drop this patch from my tree?
>>>>       
> 
> Looks like it, but I'll let Eric make the call.
> 

Thanks Aric,

Looks like the additional 'if' statement of 'inf' is unnecessary (otherwise
the _probe has already been failed), patch modified a little bit into the
following, please help confirm before I commit:

commit cc6446f6d3e81939dcc1945aab9ad734b175ce66
Author: Aric D. Blumer <aric@sdgsystems.com>
Date:   Thu Jul 30 13:42:30 2009 -0400

    USB: ohci-pxa27x: Reconfigure power settings on resume
    
    On resume, the power-related bits in UHCRHDA were not being set, so
    they would default to the reset state.  For PXA3xx devices, OCPM must
    be cleared, but it was remaining set from resume reset.
    
    Signed-off-by: Aric D. Blumer <aric@sdgsystems.com>
    Cc: David Brownell <dbrownell@users.sourceforge.net>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

diff --git a/drivers/usb/host/ohci-pxa27x.c b/drivers/usb/host/ohci-pxa27x.c
index 6180074..1229cc0 100644
--- a/drivers/usb/host/ohci-pxa27x.c
+++ b/drivers/usb/host/ohci-pxa27x.c
@@ -497,6 +497,7 @@ static int ohci_hcd_pxa27x_drv_resume(struct device *dev)
 {
        struct usb_hcd *hcd = dev_get_drvdata(dev);
        struct pxa27x_ohci *ohci = to_pxa27x_ohci(hcd);
+       struct pxaohci_platform_data *inf = dev->platform_data;
        int status;
 
        if (time_before(jiffies, ohci->ohci.next_statechange))
@@ -506,6 +507,9 @@ static int ohci_hcd_pxa27x_drv_resume(struct device *dev)
        if ((status = pxa27x_start_hc(ohci, dev)) < 0)
                return status;
 
+       /* Select Power Management Mode */
+       pxa27x_ohci_select_pmm(ohci, inf->port_mode);
+
        ohci_finish_controller_resume(hcd);
        return 0;
 }

