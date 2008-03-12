Return-Path: <linux-kernel-owner+w=401wt.eu-S1755167AbYCLVlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167AbYCLVlR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 17:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752218AbYCLVlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 17:41:00 -0400
Received: from twin.jikos.cz ([213.151.79.26]:60795 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752858AbYCLVk7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 17:40:59 -0400
Date: Wed, 12 Mar 2008 22:40:37 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Frank Munzert <frankm@linux.vnet.ibm.com>
cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: BUG: lock held when returning to user space
In-Reply-To: <47D7FAA0.1090802@linux.vnet.ibm.com>
Message-ID: <Pine.LNX.4.64.0803122236030.7266@twin.jikos.cz>
References: <47D7FAA0.1090802@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2008, Frank Munzert wrote:

> Unit record devices are not meant for concurrent read or write by 
> multiple users, that's why we need to serialize access. The driver's 
> open method uses mutex_trylock or mutex_lock_interruptible to ensure 
> exclusive access to the device, while its release method uses 
> mutex_unlock.

Which is wrong usage of mutex.

> As a consequence, lockdep complains about locks being held when returning to
> user space. We used a very simple char device driver (appended below) to
> produce this message:
> ------------------------------------------------
> testapp/2683 is leaving the kernel with locks still held!
[ ... ]
> For the vmur device driver it is crucial to have only one process access a
> given unit record device node at a given time. So having open hold the mutex
> and return to user space is exactly what we want. 

No, it is not. You probably want just to have a single-bit flag somewhere, 
and update/check it atomically, see below.

> Is there any annotation to tell lockdep to suppress or bypass this kind 
> of warning?

No, as it is a real bug if you use mutexes in this way. What happens if 
process that has called open() on your device (and has not closed it yet) 
calls fork()? 
Another breakage scenario -- what if the filedescriptor is sent through 
unix socket to another process? etc.

Look at test_and_set_bit_lock() and clear_bit_unlock(), those you want to 
use.

-- 
Jiri Kosina
SUSE Labs

