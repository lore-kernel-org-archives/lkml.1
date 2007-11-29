Return-Path: <linux-kernel-owner+w=401wt.eu-S1762093AbXK2Ce7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762093AbXK2Ce7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 21:34:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761787AbXK2Cer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 21:34:47 -0500
Received: from mail1.webmaster.com ([216.152.64.169]:3604 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761764AbXK2Ceq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 21:34:46 -0500
From: "David Schwartz" <davids@webmaster.com>
To: <larry.finger@lwfinger.net>
Cc: "LKML" <linux-kernel@vger.kernel.org>
Subject: RE: Question regarding mutex locking
Date: Wed, 28 Nov 2007 18:34:41 -0800
Message-ID: <MDEHLPKNGKAHNMBLJOLKEEBHIIAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
Importance: Normal
In-Reply-To: <474CFA64.8050608@lwfinger.net>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Wed, 28 Nov 2007 18:35:49 -0800
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Wed, 28 Nov 2007 18:35:50 -0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Thanks for the help. Someday, I hope to understand this stuff.
>
> Larry

Any code either deals with an object or it doesn't. If it doesn't deal with
that object, it should not be acquiring locks on that object. If it does
deal with that object, it must know the internal details of that object,
including when and whether locks are held, or it cannot deal with that
object sanely.

So your question starts out broken, it says, "I need to lock an object, but
I have no clue what's going on with that very same object." If you don't
know what's going on with the object, you don't know enough about the object
to lock it. If you do, you should know whether you hold the lock or not.

Either architect so this function doesn't deal with that object and so
doesn't need to lock it or architect it so that this function knows what's
going on with that object and so knows whether it holds the lock or not.

If you don't follow this rule, a lot of things can go horribly wrong. The
two biggest issues are:

1) You don't know the semantic effect of locking and unlocking the mutex. So
any code placed before the mutex is acquired or after its released may not
do what's expected. For example, you cannot unlock the mutex and yield,
because you might not actually wind up unlocking the mutex.

2) A function that acquires a lock normally expects the object it locks to
be in a consistent state when it acquires the lock. However, since your code
may or may not acquire the mutex, it is not assured that its lock gets the
object in a consistent state. Requiring the caller to know this and call the
function with the object in a consistent state creates brokenness of varying
kinds. (If the object may change, why not just release the lock before
calling? If the object may not change, why is the sub-function releasing the
lock?)

DS


