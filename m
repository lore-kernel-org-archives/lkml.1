Return-Path: <linux-kernel-owner+w=401wt.eu-S1756684AbZLYTtu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684AbZLYTtu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 14:49:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756522AbZLYTtu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 14:49:50 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:42592 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756476AbZLYTtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 14:49:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gJ6FF7KTTjAAG3+5J9N0CAa6UBs3nLizTFoUxwqlIqCzZ1OF4x+mItalcRj6g9D2nM
         NK6qu3DRopRuVatiyKpDCDZyDXJUhzeSmJR+9jt5R8p69NfVU+sHfSsawx3WyXi5vUKW
         nrl8IPMTKypQ26N1gKmIzZA+7UoDGX2p6WPjQ=
Date: Fri, 25 Dec 2009 11:49:35 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Matthew Garrett <mjg@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: -tip: origin tree boot crash
Message-ID: <20091225194935.GA23802@core.coreip.homeip.net>
References: <alpine.LFD.2.00.0912241350510.11961@localhost.localdomain> <20091225102731.GA25513@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091225102731.GA25513@elte.hu>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 25, 2009 at 11:27:31AM +0100, Ingo Molnar wrote:
> 
> Today's -tip crashed during bootup on one of my testsystems:
> 

...

> 
> The crash is due to this commit from yesterday's (v2.6.33-rc2) upstream tree:
> 
> | commit 1fdd407f4e3f2ecb453954cbebb6c22491c61853
> | Author: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> | Date:   Thu Dec 17 22:19:42 2009 -0800
> |
> |    dell-wmi: do not keep driver loaded on unsupported boxes
> |    
> |    There is no point in having the driver loaded in memory if we fail
> |    to locate particular WMI GUID.
> |    
> |    Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
> |    Acked-by: Matthew Garrett <mjg@redhat.com>
> |    Signed-off-by: Len Brown <len.brown@intel.com>
> 
> I've reverted the commit from -tip for now.
> 

Hmm, the patch is busted in one way, but it should not be crashing like
that still... I wonder what is going on. Still, the patch below should
help it a bit.

-- 
Dmitry

dell-wmi - fix condition to abort driver loading

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

The commit 1fdd407f4e3f2ecb453954cbebb6c22491c61853 incorrectly made driver
abort loading when known GUID is present when it should have done exactly
the opposite.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/platform/x86/dell-wmi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/platform/x86/dell-wmi.c b/drivers/platform/x86/dell-wmi.c
index 916ccb2..c980782 100644
--- a/drivers/platform/x86/dell-wmi.c
+++ b/drivers/platform/x86/dell-wmi.c
@@ -324,7 +324,7 @@ static int __init dell_wmi_init(void)
 {
 	int err;
 
-	if (wmi_has_guid(DELL_EVENT_GUID)) {
+	if (!wmi_has_guid(DELL_EVENT_GUID)) {
 		printk(KERN_WARNING "dell-wmi: No known WMI GUID found\n");
 		return -ENODEV;
 	}
