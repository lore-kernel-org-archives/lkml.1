Return-Path: <linux-kernel-owner+w=401wt.eu-S1761370AbYBLNC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761370AbYBLNC7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 08:02:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755159AbYBLNCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 08:02:51 -0500
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:23013 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754600AbYBLNCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 08:02:50 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=dpoui6ToRVUPj5dKYV0tAt1UKzlk6dk6pwdK1/byl3udPDHDiXGGOVpFA66KkSLbb7y6gUMBiPOn8vUgg//8p9xRMosLp+GITjJYksJO1nY13IE0d+H2TaHsKAumUPW1EKYu4YXOA089ca5vTUrMxLaYcOgEYxLYkOBqmG/1pNU=  ;
X-YMail-OSG: u9HhUGEVM1kOqzan85K38L4bzZEgbXk4X7BhP8sZMlY4KIj3xITxqBDQ64kv86aZecThPlXvAzcXC9PkwL2LRk6cMUQykIJVzqW_UwZrJL5HeqB9aQ--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: felipe.balbi@nokia.com
Subject: Re: [PATCH] USB: OTG: Fix weirdnesses on enumerating partial otg devices
Date: Tue, 12 Feb 2008 05:02:47 -0800
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       me@felipebalbi.com
References: <1202835603-10663-1-git-send-email-felipe.balbi@nokia.com> <200802120228.54123.david-b@pacbell.net> <20080212174515.GU4769@gandalf.research.nokia.com>
In-Reply-To: <20080212174515.GU4769@gandalf.research.nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802120502.48019.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 February 2008, Felipe Balbi wrote:
> On Tue, Feb 12, 2008 at 02:28:53AM -0800, David Brownell wrote:
> > On Tuesday 12 February 2008, Felipe Balbi wrote:
> > > Some devices claim
> > > to be b_host even though they have an a_connector attached to it.
> > 
> > Why not just fix that bug?  Remember that's Linux code.
> 
> The device claiming to be b_host is not linux based.

Wrong ... the meaning of that flag is:  *THIS* system is a
Linux-USB OTG device which came up in B-peripheral role, and
then through the magic of HNP morphed into the B-host role.

Linux is acting as a host at that point.  So either it's
being the A-host, or the B-host.  That flag says which.  If
the other device has the A-connector, yet we're the B-host,
then right now it is acting as an A-peripheral.  That's
exactly what HNP is designed to do.


> In any case this 
> is_b_host check won't do nothing here as we should check is
> SetFeature(b_hnp_enbable) has been succesfull.

Again wrong ... if the host side's b_hnp_enable flag is set,
that means this is a Linux-USB OTG device which came up in
A-host role and enumerated some vendor's OTG device, and
then set the b_hnp_enable flag.  (So it could in the future
use HNP to become an A-peripheral, despite having started
as an A-host.)


> A device in b_host state is not enough for allowing hnp to happen.

If the system is in b_host state, then HNP *ALREADY* happened.
So it can happen again, to go back into the b_peripheral state.
(And of course, we can't set the b_hnp_enable flag in a device
which is in the a_peripheral state...)


Seems like the root cause of the problem here is that you
have some correctly functioning code, but for some reason
you're surprised by that correct functioning.  (Maybe this
is a case where neither device is on the other's whitelist?)

- Dave

p.s. http://www.linux-usb.org/gadget/h2-otg.html
     does talk about those two bits, albeit succinctly.

