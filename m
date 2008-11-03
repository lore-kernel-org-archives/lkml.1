Return-Path: <linux-kernel-owner+w=401wt.eu-S1755914AbYKCLZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914AbYKCLZi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 06:25:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755732AbYKCLZD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 06:25:03 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:38542 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755298AbYKCLZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 06:25:00 -0500
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Richard Kennedy <richard@rsk.demon.co.uk>
Subject: Re: [PATCH 2/8] prism2_usb.c always enable the card in probe_usb
Date: Mon, 3 Nov 2008 12:25:08 +0100
User-Agent: KMail/1.9.9
Cc: gregkh <gregkh@suse.de>, lkml <linux-kernel@vger.kernel.org>
References: <1225710353.3113.5.camel@castor.localdomain> <1225710828.3113.15.camel@castor.localdomain>
In-Reply-To: <1225710828.3113.15.camel@castor.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811031225.09847.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 3. November 2008 12:13:48 schrieb Richard Kennedy:
> always enable card in probe_usb
> & update register_wlandev to match latest wlan-ng-dev tree.

This breaks both error cases.

> ---
>  drivers/staging/wlan-ng/prism2_usb.c |   14 +++++++++-----
>  1 files changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/staging/wlan-ng/prism2_usb.c b/drivers/staging/wlan-ng/prism2_usb.c
> index f1ae371..34a36c1 100644
> --- a/drivers/staging/wlan-ng/prism2_usb.c
> +++ b/drivers/staging/wlan-ng/prism2_usb.c
> @@ -110,11 +110,6 @@ static int prism2sta_probe_usb(
>  	 * linux netdevice.
>  	 */
>  	SET_NETDEV_DEV(wlandev->netdev, &(interface->dev));
> -        if ( register_wlandev(wlandev) != 0 ) {
> -		WLAN_LOG_ERROR("%s: register_wlandev() failed.\n", dev_info);
> -		result = -EIO;
> -		goto failed;
> -        }
>  
>  	/* Do a chip-level reset on the MAC */
>  	if (prism2_doreset) {

	/* Do a chip-level reset on the MAC */
	if (prism2_doreset) {
		result = hfa384x_corereset(hw,
				prism2_reset_holdtime,
				prism2_reset_settletime, 0);
		if (result != 0) {
			unregister_wlandev(wlandev);

You must remove the unregister_wlandev here.

> @@ -138,6 +133,15 @@ static int prism2sta_probe_usb(
>  
>  	wlandev->msdstate = WLAN_MSD_HWPRESENT;
>  
> +        if ( register_wlandev(wlandev) != 0 ) {
> +		WLAN_LOG_ERROR("%s: register_wlandev() failed.\n", dev_info);
> +		result = -EIO;
> +		goto failed;

"failed" fails to undo usb_get_dev() which it must do if you jump there
from this late.

	Regards
		Oliver
