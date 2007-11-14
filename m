Return-Path: <linux-kernel-owner+w=401wt.eu-S1762983AbXKNFNM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762983AbXKNFNM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 00:13:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751111AbXKNFMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 00:12:55 -0500
Received: from vms042pub.verizon.net ([206.46.252.42]:35269 "EHLO
	vms042pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798AbXKNFMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 00:12:54 -0500
Date: Tue, 13 Nov 2007 21:12:13 -0800
From: "Kok, Auke" <sofar@foo-projects.org>
Subject: Re: [PATCH 2/2] [e1000 VLAN] Disable vlan hw accel when promiscuous
 mode
In-reply-to: <000001c82679$796d1770$9c94fea9@jason>
To: Joonwoo Park <joonwpark81@gmail.com>
Cc: "'Kok, Auke'" <auke-jan.h.kok@intel.com>,
       "'Patrick McHardy'" <kaber@trash.net>,
       "'Herbert Xu'" <herbert@gondor.apana.org.au>,
       "'David Miller'" <davem@davemloft.net>, w@1wt.eu, cfriesen@nortel.com,
       netdev@vger.kernel.org, djohnson+linux-kernel@sw.starentnetworks.com,
       linux-kernel@vger.kernel.org, e1000-devel@lists.sourceforge.net
Message-id: <473A83AD.6030101@foo-projects.org>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
References: <000001c82679$796d1770$9c94fea9@jason>
User-Agent: Thunderbird 2.0.0.6 (X11/20070911)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Joonwoo Park wrote:
> 2007/11/14, Kok, Auke <auke-jan.h.kok@intel.com>:
>> Patrick McHardy wrote:
>>> Kok, Auke wrote:
>>>> Patrick McHardy wrote:
>>>>
>>>>> I already posted a patch for this, not sure what happened to it.
>>>>> Auke, any news on merging the secondary unicast address support?
>>>> I dropped the ball on that one. Care to resend it and send me one for
>>>> e1000e as well?
>>> Patch for e1000 attached.
>>>
>>> Does e1000e also work with PCI cards if I add the proper IDs?
>>> Otherwise I could only send an untested patch.
>>
>> Johnwoo,
>>
>> your patch unfortunately does not apply after patrick's unicast patch,
>>
>> also, ich8lan support is removed from e1000 in the e1000 version in
>> jgarzik/netdev-2.6 #upstream as planned (moved over to e1000e!).
>>
>> Can you resend your patch so that it applies to jgarzik/netdev-2.6 #upstream with
>> Patrick's patch applied? That would help a lot. And possibly do the e1000e patch
>> as well :)
>>
> 
> This is a patch for the jgarzik/netdev-2.6 #upstream with Patrick's one was applied.
> But the ich8lan stuff was not removed at this patch.


no, my TODO list is insane at the moment :)

thanks for the patch. I'll apply and rip the ich8 workarounds out myself later
when appropriate.

> I'll work e1000e too :-)

awesome, looking forward to that.

Auke

> 
> Thanks.
> Joonwoo
> 
> [E1000]: Disable vlan hw accel when promiscuous mode
> 
> Even though netdevice is in the promiscuous mode, we should receive all of ingress packets.
> This disable the vlan filtering feature when a vlan hw accel configured e1000 device goes into promiscuous mode.
> This make packets visible to sniffers though it's not vlan id of itself.
> 
> Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>
> 
> ---
>  drivers/net/e1000/e1000_main.c |   23 ++++++++++++++++++-----
>  1 files changed, 18 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/e1000/e1000_main.c b/drivers/net/e1000/e1000_main.c
> index 5fd5f51..edf2ced 100644
> --- a/drivers/net/e1000/e1000_main.c
> +++ b/drivers/net/e1000/e1000_main.c
> @@ -2425,7 +2425,7 @@ e1000_set_rx_mode(struct net_device *netdev)
>  	struct e1000_hw *hw = &adapter->hw;
>  	struct dev_addr_list *uc_ptr;
>  	struct dev_addr_list *mc_ptr;
> -	uint32_t rctl;
> +	uint32_t rctl, ctrl;
>  	uint32_t hash_value;
>  	int i, rar_entries = E1000_RAR_ENTRIES;
>  	int mta_reg_count = (hw->mac_type == e1000_ich8lan) ?
> @@ -2442,13 +2442,23 @@ e1000_set_rx_mode(struct net_device *netdev)
>  	/* Check for Promiscuous and All Multicast modes */
>  
>  	rctl = E1000_READ_REG(hw, RCTL);
> +	ctrl = E1000_READ_REG(hw, CTRL);
>  
>  	if (netdev->flags & IFF_PROMISC) {
>  		rctl |= (E1000_RCTL_UPE | E1000_RCTL_MPE);
> -	} else if (netdev->flags & IFF_ALLMULTI) {
> -		rctl |= E1000_RCTL_MPE;
> +		if (adapter->hw.mac_type != e1000_ich8lan) {
> +			if (ctrl & E1000_CTRL_VME)
> +				rctl &= ~E1000_RCTL_VFE;
> +		}
>  	} else {
> -		rctl &= ~E1000_RCTL_MPE;
> +		if (adapter->hw.mac_type != e1000_ich8lan) {
> +			if (ctrl & E1000_CTRL_VME)
> +				rctl |= E1000_RCTL_VFE;
> +		} else if (netdev->flags & IFF_ALLMULTI) {
> +			rctl |= E1000_RCTL_MPE;
> +		} else {
> +			rctl &= ~E1000_RCTL_MPE;
> +		}
>  	}
>  
>  	uc_ptr = NULL;
> @@ -4967,7 +4977,10 @@ e1000_vlan_rx_register(struct net_device *netdev, struct vlan_group *grp)
>  		if (adapter->hw.mac_type != e1000_ich8lan) {
>  			/* enable VLAN receive filtering */
>  			rctl = E1000_READ_REG(&adapter->hw, RCTL);
> -			rctl |= E1000_RCTL_VFE;
> +			if (netdev->flags & IFF_PROMISC)
> +				rctl &= ~E1000_RCTL_VFE;
> +			else
> +				rctl |= E1000_RCTL_VFE;
>  			rctl &= ~E1000_RCTL_CFIEN;
>  			E1000_WRITE_REG(&adapter->hw, RCTL, rctl);
>  			e1000_update_mng_vlan(adapter);
> ---
> 
> -
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

