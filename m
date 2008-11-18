Return-Path: <linux-kernel-owner+w=401wt.eu-S1752917AbYKRObH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917AbYKRObH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 09:31:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751421AbYKROaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 09:30:52 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:18159 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbYKROav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 09:30:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=iicgqBNLx9CvLZnwSexKVGBV1alpTa0IArFa0B8bbs/bJ/TMFyXkP7W5OcReyj6w6c
         /Y8pJaqJbmHwKTaQtsR1QgJwecY1rp96ZeND2LbPeSAZXmho28U68QJQqbvBeqoHqJoH
         wIW3SgR9KLvaCraMDTU3xvLVDr+pjWQME7UO0=
Message-ID: <4922D195.9010505@tuffmail.co.uk>
Date: Tue, 18 Nov 2008 14:30:45 +0000
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Jay Cliburn <jcliburn@gmail.com>
CC: csnook@redhat.com, atl1-devel@lists.sourceforge.net,
       linux-kernel <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org
Subject: Re: [atl1-devel] atl2: don't mess up irq on suspend/resume (probably
 msi only)
References: <49201401.1060600@tuffmail.co.uk>	<4921E574.3090602@tuffmail.co.uk> <20081117181336.1a270561@osprey.hogchain.net>
In-Reply-To: <20081117181336.1a270561@osprey.hogchain.net>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jay Cliburn wrote:
> [adding netdev to cc list]
>
> On Mon, 17 Nov 2008 21:43:16 +0000
> Alan Jenkins <alan-jenkins@tuffmail.co.uk> wrote:
>
>
>   
>> Don't listen to me.  The problem went away because when I was testing
>> my patch, I plugged the ethernet in and actually used it.  My patch
>> doesn't seem to fix anything.
>>
>> So I now have the steps to reproduce this warning: remove the ethernet
>> cable and suspend.
>>
>> Also, I was speaking rubbish because the warning isn't on the resume
>> path.  It seems to be when network-manager re-opens the device on
>> resume.
>>
>> I'll have another look for possible culprits.  Hints appreciated :).
>>     
>
> Does this help?
>   

Ah! Yes, that fixes it, thanks.

> diff --git a/drivers/net/atlx/atl2.c b/drivers/net/atlx/atl2.c
> index f5bdc92..5b292f0 100644
> --- a/drivers/net/atlx/atl2.c
> +++ b/drivers/net/atlx/atl2.c
> @@ -1690,10 +1690,6 @@ static int atl2_resume(struct pci_dev *pdev)
>  
>  	ATL2_WRITE_REG(&adapter->hw, REG_WOL_CTRL, 0);
>  
> -	err = atl2_request_irq(adapter);
> -	if (netif_running(netdev) && err)
> -		return err;
> -
> 	atl2_reset_hw(&adapter->hw);
>  
> 	if (netif_running(netdev))
>   

