Return-Path: <linux-kernel-owner+w=401wt.eu-S1757509AbZAOHD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757509AbZAOHD3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 02:03:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755885AbZAOHDU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 02:03:20 -0500
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:27710 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755807AbZAOHDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 02:03:20 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=tdUoFdPdSdqL4b3cGpqqGgvbDIKZmF40s2LbMXai8DePqUnLgMhYCI/Fq7qKMUVHmITCpffkuV2nWll+gT9yXgnxtT1ZKxE1aA3Iv1tscG17pHhvtykhVzLIzGqLVy2e41wcQPUGv27NDsglrA4PV+Tmr1ae91sZeyIlSG07Ze4=  ;
X-YMail-OSG: EMDienAVM1nkYamHmljcjXBNpqo94rgzbtrHqYx68RJqENsamY8mtd_buty0vvnqElaX3NtheJ8BW4q8XWr6BTx6.DBkXxMDlnqeWkJvRWGyvzFaiuz1MkGV7KNYT_Q3c8GwYgfaXoxqkaPuNtetuX0d
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Mark Brown <broonie@sirena.org.uk>
Subject: Re: [patch 2.6.28-rc3] regulator: add REGULATOR_MODE_OFF
Date: Wed, 14 Jan 2009 23:03:09 -0800
User-Agent: KMail/1.9.10
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, lkml <linux-kernel@vger.kernel.org>
References: <200811091531.46003.david-b@pacbell.net> <200811161458.17212.david-b@pacbell.net> <20081117015127.GA10883@sirena.org.uk>
In-Reply-To: <20081117015127.GA10883@sirena.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200901142303.09217.david-b@pacbell.net>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 16 November 2008, Mark Brown wrote:
> > Are you arguing that there should be some new regulator_ops call to
> > expose the actual regulator state?  If so, then what should happen to
> 
> Yes, exactly - possibly multiple calls.

OK, so I finally got back to this issue.  I'll post a patch
with such a separate call in a moment ... just a single status
value, sufficient for the need I observe, and only exposed
through sysfs since it's more useful just now as a kind of
introspection.  Example:  troubleshooting, as we previously
discussed; or, I can see some regulators that are wrongly
enabled, primarily because of bootloader goofage.

That raises an issue:  how can Linux get such regulators to
turn off?  Clock frameworks have the same issue, and they
tend to resolve this with a SoC-specific Kconfig option to
disable unused clocks (in a late_initcall, after everthing
has had a chance to start up).  That conserves power.

I'm thinking it'd be worth having a similar Kconfig option
for regulators too.  It could kick in regulator core code to
call regulator_ops.disable() whenever regulator_dev.use_count
is zero, possibly warning if !regulator_ops.is_disabled().
(Handling constraints.always_on too.)

Comments?

- Dave

