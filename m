Return-Path: <linux-kernel-owner+w=401wt.eu-S1755438AbYKCLsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438AbYKCLsa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 06:48:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752548AbYKCLsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 06:48:22 -0500
Received: from anchor-post-33.mail.demon.net ([194.217.242.91]:3347 "EHLO
	anchor-post-33.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752522AbYKCLsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 06:48:21 -0500
Subject: Re: [PATCH 2/8] prism2_usb.c always enable the card in probe_usb
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Oliver Neukum <oliver@neukum.org>
Cc: gregkh <gregkh@suse.de>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <200811031225.09847.oliver@neukum.org>
References: <1225710353.3113.5.camel@castor.localdomain>
	 <1225710828.3113.15.camel@castor.localdomain>
	 <200811031225.09847.oliver@neukum.org>
Content-Type: text/plain
Date: Mon, 03 Nov 2008 11:47:57 +0000
Message-Id: <1225712877.3113.44.camel@castor.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-11-03 at 12:25 +0100, Oliver Neukum wrote:
> Am Montag, 3. November 2008 12:13:48 schrieb Richard Kennedy:
> > always enable card in probe_usb
> > & update register_wlandev to match latest wlan-ng-dev tree.
> 
> This breaks both error cases.
> 
> > ---
> >  drivers/staging/wlan-ng/prism2_usb.c |   14 +++++++++-----
> >  1 files changed, 9 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/staging/wlan-ng/prism2_usb.c b/drivers/staging/wlan-ng/prism2_usb.c
> > index f1ae371..34a36c1 100644
> > --- a/drivers/staging/wlan-ng/prism2_usb.c
> > +++ b/drivers/staging/wlan-ng/prism2_usb.c
> > @@ -110,11 +110,6 @@ static int prism2sta_probe_usb(
> >  	 * linux netdevice.
> >  	 */
> >  	SET_NETDEV_DEV(wlandev->netdev, &(interface->dev));
> > -        if ( register_wlandev(wlandev) != 0 ) {
> > -		WLAN_LOG_ERROR("%s: register_wlandev() failed.\n", dev_info);
> > -		result = -EIO;
> > -		goto failed;
> > -        }
> >  
> >  	/* Do a chip-level reset on the MAC */
> >  	if (prism2_doreset) {
> 
> 	/* Do a chip-level reset on the MAC */
> 	if (prism2_doreset) {
> 		result = hfa384x_corereset(hw,
> 				prism2_reset_holdtime,
> 				prism2_reset_settletime, 0);
> 		if (result != 0) {
> 			unregister_wlandev(wlandev);
> 
> You must remove the unregister_wlandev here.
> > @@ -138,6 +133,15 @@ static int prism2sta_probe_usb(
> >  
> >  	wlandev->msdstate = WLAN_MSD_HWPRESENT;
> >  
> > +        if ( register_wlandev(wlandev) != 0 ) {
> > +		WLAN_LOG_ERROR("%s: register_wlandev() failed.\n", dev_info);
> > +		result = -EIO;
> > +		goto failed;
> 
> "failed" fails to undo usb_get_dev() which it must do if you jump there
> from this late.
> 
> 	Regards
> 		Oliver

Oliver,
thanks for that, I will tidy it up & post a patch.

prism2_doreset is 0 by default, so that hunk of code will not usually
get called. hfa384x_corereset doesn't do much on usb, and holdtime &
settletime aren't used at all. So more targets for clean up I guess :)

regards
Richard


