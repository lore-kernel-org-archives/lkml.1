Return-Path: <linux-kernel-owner+w=401wt.eu-S1754659AbYJZM6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659AbYJZM6g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 08:58:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753258AbYJZM62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 08:58:28 -0400
Received: from outbound-mail-04.bluehost.com ([69.89.21.14]:35339 "HELO
	outbound-mail-04.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753237AbYJZM61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 08:58:27 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sun, 26 Oct 2008 08:58:27 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=uniscape.net;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Aw/B0dzEtiZBPYK7gNJaj/ak5SaqRqxNbmzlmvWdqdxE9CnINSFf8PU1FKpe8qHMwTnUU/T02asGy/niosN7ewCWQ7XI/+f4paXOdo+fb9a+ETkpl04LzZfGUYViIB2m;
Message-ID: <490467CD.3000402@uniscape.net>
Date: Sun, 26 Oct 2008 20:51:25 +0800
From: Yu Zhao <yu.zhao@uniscape.net>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       greg@kroah.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       stable@kernel.org, Rakib Mullick <rakib.mullick@gmail.com>
Subject: Re: [PATCH] pci: Fixing drivers/pci/search.c compilation warning.
References: <b9df5fa10809280816u23ef3021k7eee287a237b72ae@mail.gmail.com> <20080928163211.GR27204@parisc-linux.org> <20081021011308.GA3889@parisc-linux.org>
In-Reply-To: <20081021011308.GA3889@parisc-linux.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Identified-User: {2990:host272.hostmonster.com:uniscape:uniscape.net} {sentby:smtp auth 58.38.26.55 authed with yu.zhao@uniscape.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> This patch seems to have been overlooked.  It also seems to have had
> some kind of midair collision with a patch from Greg that ignored the
> real bug I found.
> 
> Here's an updated version.  I think it should also be applied to
> -stable.
> 
> ----
> 
> Subject: [PCI] Fix reference counting bug
> 
> pci_get_subsys() will decrement the reference count of the device that
> it starts searching from.  Unfortunately, the pci_find_device() interface 
> will already have decremented the reference count of the device earlier,
> so the device will end up losing all reference counts and be freed.
> 
> We can fix this by incrementing the reference count of the device to
> start searching from before calling pci_get_subsys().
> 
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
> 
> diff --git a/drivers/pci/search.c b/drivers/pci/search.c
> index 4edfc47..5af8bd5 100644
> --- a/drivers/pci/search.c
> +++ b/drivers/pci/search.c
> @@ -166,6 +166,7 @@ struct pci_dev *pci_find_device(unsigned int vendor, unsigned int device,
>  {
>  	struct pci_dev *pdev;
>  
> +	pci_dev_get(from);
>  	pdev = pci_get_subsys(vendor, device, PCI_ANY_ID, PCI_ANY_ID, from);
>  	pci_dev_put(pdev);
>  	return pdev;
> @@ -270,12 +271,8 @@ static struct pci_dev *pci_get_dev_by_id(const struct pci_device_id *id,
>  	struct pci_dev *pdev = NULL;
>  
>  	WARN_ON(in_interrupt());
> -	if (from) {
> -		/* FIXME
> -		 * take the cast off, when bus_find_device is made const.
> -		 */
> -		dev_start = (struct device *)&from->dev;
> -	}
> +	if (from)
> +		dev_start = &from->dev;
>  	dev = bus_find_device(&pci_bus_type, dev_start, (void *)id,
>  			      match_pci_dev_by_id);
>  	if (dev)

This reminds me of other problems of PCI search functions.

The 'dev_start' is passed to bus_find_device(), and its 'knode_bus' 
reference count is decreased by klist_iter_init_node() in that function. 
The problem is the reference count may be already decrease to 0 because 
the PCI device 'from' is hot-plugged off (e.g., pci_remove_bus) when the 
search goes. A warning is fired when klist_iter_init_node() detects the 
reference count becomes 0.

Some code uses pci_find_device() in a way that is not safe with the 
hotplug, because a device may be destroyed after bus_find_device() 
returns it and before it's held by pci_dev_get() in the next round. 
Following is an example from a random grep:

for ( ;; )
{
	if ((dev_netjet = pci_find_device(PCI_VENDOR_ID_TIGERJET,
			PCI_DEVICE_ID_TIGERJET_300,  dev_netjet))) {
		ret = njs_pci_probe(dev_netjet, cs);
		...
	}
	...
}

And some others use pci_get_bus_and_slot(), which has similar problem as 
above.


Thanks,
Yu
