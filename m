Return-Path: <linux-kernel-owner+w=401wt.eu-S1753557AbYGLFcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557AbYGLFcx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 01:32:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751278AbYGLFcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 01:32:45 -0400
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:22441 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751031AbYGLFcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 01:32:45 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=iLAbvEmOClKA7KY4u/iFSqkwR7/h+cGYQV3PkQ8+N5vFsDZtC7LUf1NAA8Ui6vNCV6Qj3Q3TRP2eaRAUuPmvxmNQvMGB4Ncu/CofZsWkhYJHxiTZ4yZSM6+fKmiw02A36vB3JJL9V2NzsB+TrySPbavEPqMXxOH1ff5B3tp3fAQ=  ;
X-YMail-OSG: 40He7s4VM1lB_PEED6xqRc4XDZKrtCuDsiinKOI1kOnJLvmp68WPMoZrv_zw2CLQ8HRGbJzSUWVif_tPG.KBIcf28m32WM.m7uZBF__Mlg--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] gpiolib: Allow user-selection
Date: Fri, 11 Jul 2008 22:32:43 -0700
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>, Michael Buesch <mb@bu3sch.de>,
       sfr@canb.auug.org.au, linux-kernel@vger.kernel.org
References: <200807022346.53222.mb@bu3sch.de> <200807031428.00765.david-b@pacbell.net> <20080703230802.GB21898@kroah.com>
In-Reply-To: <20080703230802.GB21898@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200807112232.43293.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 July 2008, Greg KH wrote:
> > The scenario is that gpios sometimes get initialized very early,
> > as part of board setup before kmalloc or irqs work, so when they
> > get registered sometimes there's work left over for later.  All
> > that's needed is a predicate to test whether that class can be
> > used as a parameter to stuff like device_create_drvdata() and
> > sysfs_create_group().
> 
> If you want to see if a class has any devices in it, just do a search
> for any device instead of poking into that field.  Or I can wrap that up
> in the driver core if needed.

That would require taking driver model mutexes before
tasking is working and driver_init() is called.  GPIOs
are regularly used *really* early in board setup ... even
before IRQs are working.

Are driver model searches really expected to work then??

Seems simpler to me to just check "is pointer NULL",
when we know that the pointer is initialized by the
class initialization, and (because the relevant struct
is zero-initialized) null beforehand.  That works more
or less any point during kernel initialization ... not
just after the first task is running.  Plus it's not
as expensive.  :)

- Dave
