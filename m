Return-Path: <linux-kernel-owner+w=401wt.eu-S1761694AbYBZScg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761694AbYBZScg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 13:32:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754476AbYBZSc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 13:32:27 -0500
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:27460 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756658AbYBZSc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 13:32:27 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Received:Date:From:To:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=xIW5HvGCACmUq1fLtqAc9a9+6HrvzWo7tddQL/bBoT8MhVooOw4jSh0rIx8CzPZRpvHZMn2Km3Nm3ooY4QusDRS+vkNlFamDOk6vbL1AvPwt4BdVLXnduVYptvsu+kG3AdLimmgzoctG9DRgsW83uq1CdKmOL8fg5wTXAHjqLO8=  ;
X-YMail-OSG: OWoTyA8VM1kiFJH_6uC7kx0X2DegFVkTXjEUN3hXu269tsymZ.OqKHXz2fm42uzEAdZp6q36Ow--
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 26 Feb 2008 10:32:24 -0800
From: David Brownell <david-b@pacbell.net>
To: linux-kernel@vger.kernel.org
Subject: (regression) kernel/timeconst.h bugs with HZ=128
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080226183224.DE5BB8DE50@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I see these warnings on 32 bit ARM systems:

  CC      kernel/time.o
kernel/time.c: In function 'msecs_to_jiffies':
kernel/time.c:472: warning: integer constant is too large for 'long' type
kernel/time.c: In function 'usecs_to_jiffies':
kernel/time.c:487: warning: integer constant is too large for 'long' type

Line 472: 
	return ((u64)MSEC_TO_HZ_MUL32 * m + MSEC_TO_HZ_ADJ32)
line 487:
	return ((u64)USEC_TO_HZ_MUL32 * u + USEC_TO_HZ_ADJ32)

The problem seems to be that these constants from kernel/timeconst.h
have too many digits:

#define ONLY_THIRTYTWO_BITS	0x01234567

#define MSEC_TO_HZ_ADJ32        0x3f7ced916
#define USEC_TO_HZ_ADJ32        0xfffbce4217d

Those *_ADJ32 constants should have "ULL" suffixes, yes?
Adding that by hand resolves the problem, but only until
the next time that header file gets regenerated.

Someone with observable Perl-fu should fix this ...

- Dave

