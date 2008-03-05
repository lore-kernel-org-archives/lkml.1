Return-Path: <linux-kernel-owner+w=401wt.eu-S1761651AbYCERjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761651AbYCERjX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 12:39:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754926AbYCERjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 12:39:12 -0500
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:28864 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752070AbYCERjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 12:39:11 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=C0is33ICJuuU22/nPz0nMtRs6qVRAs1oCH8K7yIFEiWrBc9P7J9eGeMZBlqYuWH3jegPB0aiVK/5uHGjSOalXSXz8NZ4v4T3CozFakrXpKRJm5K6ewWVetKdsCdO/lo2LK7mGcC35F9EyROTwkJXtLOL/F7N26Wf0VsW7o2ZXMk=  ;
X-YMail-OSG: NlgttOIVM1nqwVRHw9i961TP4lb6vaQWb.YF.ftnMnFojXS0gJwO7YWKfvq_CgZ8iM3sNGILZg--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: USB OOPS 2.6.25-rc2-git1
Date: Wed, 5 Mar 2008 09:39:08 -0800
User-Agent: KMail/1.9.6
Cc: Andre Tomt <andre@tomt.net>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
References: <Pine.LNX.4.44L0.0803051145080.4750-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0803051145080.4750-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803050939.08780.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 March 2008, Alan Stern wrote:
> On Tue, 4 Mar 2008, David Brownell wrote:
> 
> > How does the appended patch look?
> 
> It looks very good.  Do you think there should be an "else" clause for 
> the "if ((status & STS_IAA) || !(cmd & CMD_IAAD))" test?  That's the 
> pathway one would observe with a controller that implements IAA very 
> slowly or not at all.  There doesn't seem to be anything more the HCD 
> can do about it, but you could print a log message.

It's already chatty enough, IMO.  :)


> 
> > > Given sufficiently bizarre hardware we can't be 
> > > certain that things won't still go wrong on occasion, but this is the
> > > best we can do for now -- weird hardware can be handled as it arises.
> > 
> > The appended patch does include a bit of paranoia around IAA and IAAD;
> > I figure it can't hurt, although at this point I have no particular
> > reason to believe anyone except VIA has bugs in those areas.
> 
> There's still Bugzilla #8692.  That one appears to be an individual
> hardware failure, though, not a systematic bug.

Maybe; I noticed the "IAAD wasn't clear" message, but that should
actually have been tested earlier (before the completions fired).
So I'm not sure I trust it.


> > Yeah, that seems like a better place to do it.  All the other callers
> > guarantee ehci->reclaim is non-null before calling it.  The fact that
> > it happens in this case suggests IAAD and/or IAAD didn't get cleared
> > properly.
> 
> There is one place where ehci-hcd.c doesn't make that guarantee:

... which is pretty wierd anyway.


> @@ -757,7 +757,7 @@ static void unlink_async (struct ehci_hcd *eh
>  static void unlink_async (struct ehci_hcd *ehci, struct ehci_qh *qh)
>  {
>  	/* failfast */
> -	if (!HC_IS_RUNNING(ehci_to_hcd(ehci)->state))
> +	if (!HC_IS_RUNNING(ehci_to_hcd(ehci)->state) && ehci->reclaim)
>  		end_unlink_async(ehci);
>  
>  	/* if it's not linked then there's nothing to do */
> 
> But if you take out the WARN_ON at the start of end_unlink_async then 
> this isn't needed.

Right, that's gone.

- Dave

