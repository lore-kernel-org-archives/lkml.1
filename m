Return-Path: <linux-kernel-owner+w=401wt.eu-S1753041AbYKRTv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041AbYKRTv5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 14:51:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752399AbYKRTvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 14:51:49 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:37867 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319AbYKRTvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 14:51:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=Uj5oYjY2Tpjw8Gunri7MshmhuWHjzDV/RgMiXtHsIaQN98wmAZDHgf2glgYOhFb2F9
         i/w4rhsAUFwUUC2HGUbeT7hkLvPeFlwINsHIJ7rzM7iBDpykH96O+JdmJHoD+x5Jrycl
         l21T8CVO/uoRA49qpYcramJrCTKmvM7RVRMBE=
Message-ID: <49231CCB.8010900@tuffmail.co.uk>
Date: Tue, 18 Nov 2008 19:51:39 +0000
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Jay Cliburn <jcliburn@gmail.com>
CC: csnook@redhat.com, atl1-devel@lists.sourceforge.net,
       linux-kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Subject: Re: [atl1-devel] atl2: don't mess up irq on suspend/resume (probably
 msi only)
References: <49201401.1060600@tuffmail.co.uk>	<4921E574.3090602@tuffmail.co.uk> <20081117181336.1a270561@osprey.hogchain.net> <4922D195.9010505@tuffmail.co.uk> <4922FD09.2070007@tuffmail.co.uk>
In-Reply-To: <4922FD09.2070007@tuffmail.co.uk>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Jenkins wrote:
> Alan Jenkins wrote:
>> Jay Cliburn wrote:
>>> [adding netdev to cc list]
>>>
>>> On Mon, 17 Nov 2008 21:43:16 +0000
>>> Alan Jenkins <alan-jenkins@tuffmail.co.uk> wrote:
>>>
>>>
>>>> Don't listen to me. The problem went away because when I was testing
>>>> my patch, I plugged the ethernet in and actually used it. My patch
>>>> doesn't seem to fix anything.
>>>>
>>>> So I now have the steps to reproduce this warning: remove the ethernet
>>>> cable and suspend.
>>>>
>>>> Also, I was speaking rubbish because the warning isn't on the resume
>>>> path. It seems to be when network-manager re-opens the device on
>>>> resume.
>>>>
>>>> I'll have another look for possible culprits. Hints appreciated :).
>>> Does this help?
>>
>> Ah! Yes, that fixes it, thanks.
>
> Just noticed another problem. If I suspend with the cable plugged in,
> I get a warning message about freeing the IRQ
which was caused by your patch.  It works better (for both cable plugged and unplugged cases) if I do this instead:


diff --git a/drivers/net/atlx/atl2.c b/drivers/net/atlx/atl2.c
index f5bdc92..8571e8c 100644
--- a/drivers/net/atlx/atl2.c
+++ b/drivers/net/atlx/atl2.c
@@ -1690,9 +1690,11 @@ static int atl2_resume(struct pci_dev *pdev)
 
 	ATL2_WRITE_REG(&adapter->hw, REG_WOL_CTRL, 0);
 
-	err = atl2_request_irq(adapter);
-	if (netif_running(netdev) && err)
-		return err;
+	if (netif_running(netdev)) {
+		err = atl2_request_irq(adapter);
+		if (err)
+			return err;
+	}
 
 	atl2_reset_hw(&adapter->hw);
 


