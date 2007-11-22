Return-Path: <linux-kernel-owner+w=401wt.eu-S1752330AbXKVQCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752330AbXKVQCx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 11:02:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751053AbXKVQCq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 11:02:46 -0500
Received: from wx-out-0506.google.com ([66.249.82.235]:30566 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbXKVQCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 11:02:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=NoyepN8kVE5HRT4vhupjMsPU0ez5ONoh/m/66NXQyl7o9VQcJhsgOI2v0ufQpxjnFpx6VO/IPZqI0tUfIwyoRTpmtRzbuQzMwc1JMtgGSVtCxP8ot19N2ulOQZTxooJlGDXK3cSHqazoRiAvS8L7OTJQVbFoYF6brb34oeU9wAs=
Message-ID: <c384c5ea0711220802i21e3df45q1d328aea63e7ebf4@mail.gmail.com>
Date: Thu, 22 Nov 2007 17:02:44 +0100
From: "Leon Woestenberg" <leon.woestenberg@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Use of mutex in interrupt context flawed/impossible, need advice.
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,


I'm converting an out-of-tree (*1) driver from binary semaphore to mutex.

Userspace updates a look-up-table using write(). The driver tries to
write this LUT to the FPGA in the (video frame) interrupt handler. It
is important that the LUT is consistent and thus changed atomically.
Note that it is not important that the LUT is updated each interrupt.

The current approach is to try-down()ing a binary semaphore in
interrupt context, and write the LUT to the FPGA if the semaphore was
down()ed, do nothing else.
The write() down()s the semaphore as well before updating the
in-driver-copy of the LUT, then up()s it again.

I understand this design is not clean (*2), and not even possible with
mutexes, as mutex_trylock() is not interrupt safe.

My current approach would be to have userspace write into a shadow
copy, and use a spinlock to update the live copy. The interrupt then
would try a spinlock.

My feeling is that we have a  valid use of mutex_trylock() in
interrupt context; "i.e. update LUT if we can do so consistently and
in time, or not at all".

I would like to know why this is not so, and if someone has a cleaner
proposal than the "try spinlock" approach?

Regards,
-- 
Leon

*1: specific to driving a certain FPGA with certain logic. I can post
the source code on request.
*2: http://lkml.org/lkml/2007/6/23/143
