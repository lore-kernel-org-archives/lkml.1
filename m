Return-Path: <linux-kernel-owner+w=401wt.eu-S1753810Ab0ADXB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810Ab0ADXB5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 18:01:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753025Ab0ADXB4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 18:01:56 -0500
Received: from mta5.srv.hcvlny.cv.net ([167.206.4.200]:61326 "EHLO
	mta5.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218Ab0ADXB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 18:01:56 -0500
Date: Mon, 04 Jan 2010 18:01:17 -0500
From: Michael Breuer <mbreuer@majjas.com>
Subject: tty_io.c  - disassociate_ctty attempted to write to tty = NULL
 question/problem?
To: linux-kernel@vger.kernel.org
Message-id: <4B42733D.6050704@majjas.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.5)
 Gecko/20091204 Lightning/1.0b2pre Thunderbird/3.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While looking into something else, had debugging turned on and came 
across this:
Jan  1 15:11:42 mail kernel: error attempted to write to tty [0x(null)] 
= NULL

[running 2.6.32 from git - with the recent devpts ionode patch applied]

Looks like this happens when (at least in my case), init retarts mingetty.

Basically:

do_exit -> disassocate_ctty(1) (for tty1).
disassociate->vhangup->do_tty_hangup

In do_tty_hangup, p->signal->tty is set to NULL, where p==current.

On return, the aforementioned error message is generated.

I'm thinking that the cleanup of the tty structure is therefore not 
happening properly. I wrote a small patch to enter the cleanup code 
anyway in this once instance and saw no changes to the system behavior.

Main question is what should be going on here? From my testing, it looks 
like this pretty much a special case involving init->mingetty start/stop 
on the tty where the console is connected (usually tty1).

I got here by trying to figure out why I'm getting sky2 interrupt errors 
- but only when I've got a mingetty running on tty1.




