Return-Path: <linux-kernel-owner+w=401wt.eu-S1757866AbYBZHNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757866AbYBZHNe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 02:13:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751470AbYBZHN0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 02:13:26 -0500
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:26413 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753183AbYBZHNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 02:13:25 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Ymls423yzhV6OOtMK60lGsK/Hl8dp7tA+hsiFh5eKly3c5KzifWJXHZZ1T4VOIXXJzENJhPQfnUM2euUsZJE7AUReyLlNOd8JzGUNjwdD+EKBXIvleVMwF9/OrpOXvocKioDtPkdljmBLGgodldVNnNnRHu4on17fMjHvs4nqps=  ;
X-YMail-OSG: 2BQFp6IVM1kozpJaIM_eAEDUuC.MHYX5jdc0qEnBxvi6zEeuAXfRlSlTV6LFxNACM4g8vl0aiA--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] Fundamental flaw in system suspend, exposed by freezer removal
Date: Mon, 25 Feb 2008 23:13:23 -0800
User-Agent: KMail/1.9.6
Cc: linux-pm@lists.linux-foundation.org,
       Kernel development list <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0802251439030.5536-100000@iolanthe.rowland.org> <200802252325.09439.rjw@sisk.pl>
In-Reply-To: <200802252325.09439.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200802252313.23399.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This "flaw" isn't a new thing, of course.  I remember pointing out the rather
annoying proclivity of the PM framework to deadlock when suspend() tried to
remove USB devices ... back around 2.6.10 or so.  Things have shuffled around
a bit, and gotten better in some cases, but not fundamentally changed.

It may be more accurate to say that now we understand some constraints on
device tree management policies ... ones we had previously assumed should
not be issues.  (But AFAICT, without actually considering the question.
Now we know the right question to ask!)


On Monday 25 February 2008, Rafael J. Wysocki wrote:
> IMO the device driver should assure that no new children will be registered
> concurrently with the ->suspend() method (IOW, ->suspend() should wait for
> all such registrations to complete and should prevent any new ones from
> being started) and it should make it impossible to register any new children
> after ->suspend() has run.  It's the driver's problem how to achieve that.

There's also the case where it's framework code that handles the additions
rather than the parent device.  That would be typical for many bridge, hub,
or adapter type drivers ... you may be thinking mostly about drivers acting
as "leaf" nodes in the device tree, at least in terms of real hardware nodes.

Yes, "require that policy from such framework code too".  Just trying to be
sure the description doesn't have gaping holes in the middle.  :)

I can think of a bunch of serial busses where framework code has that sort
of responsiblity.  USB, SPI, I2C ... "legacy" I2C drivers would all need
to be taught not to create/remove children during those intervals, lacking
"new style" conversion (which makes them work more like normal drivers).

- Dave

