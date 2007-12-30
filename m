Return-Path: <linux-kernel-owner+w=401wt.eu-S1756161AbXL3GnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161AbXL3GnA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 01:43:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752257AbXL3Gmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 01:42:51 -0500
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:23864 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751657AbXL3Gmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 01:42:50 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=t61EflC2eBJqVlRKuLF1LFxKW5x0OvDRHpsgSny90+EQP4KeBekKX+KgfXwGzsn1jAlRLgDJMnMTd2rLdY2Yuxc/0+DvFZ2OjJ49Di4Q7uM6rWXLxbbnpr9SVABjixax/+lGljfvoDsvZ+EWo3zF+c/vKs8ZxM3bXUjpqmb5Hds=  ;
X-YMail-OSG: T6foZt4VM1nw12s8EtuC8Q7cKcZvmRJsX3A3.cKk_ueHzOLctdkgES_7C1nTNLJSQYiwTMyQrQ--
From: David Brownell <david-b@pacbell.net>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 01/12] Use mutex instead of semaphore in driver core
Date: Sat, 29 Dec 2007 22:42:47 -0800
User-Agent: KMail/1.9.6
Cc: Dave Young <hidave.darkstar@gmail.com>, Greg KH <gregkh@suse.de>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
References: <Pine.LNX.4.44L0.0712291652540.26261-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0712291652540.26261-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200712292242.47960.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 29 December 2007, Alan Stern wrote:
> lockdep warns whenever a task acquires a mutex while holding another
> mutex of the same kind (that is, the same member in another structure
> of the same type).  But there are lots of places where the kernel needs
> to acquire dev->sem for one device while already holding
> dev->parent->sem.

Not just devices.  I've seen the same issue with genirq when
enabling or disabling wakeup:  while holding irq_desc[354].lock
it must also acquire the parent IRQ's irq_desc[37].lock so it
can update that parent IRQ's wake flag ... because the wake
signal goes from the child up to the parent up to the logic
that kicks the clock framework and thence the CPU, and software
must enable at least some of those paths by hand.

And lockdep says "[ INFO: possible recursive locking detected ]".
But the analysis is "ignore that one, it's a false alarm".


> There's no way to remove these, which means there's 
> no way to prevent lockdep from issuing a warning.

There may be no *efficient* way to do that.  If it tracked
every lock individually these false alarms could go away;
but that would increase the overhead to create and destroy
such locks too.

Such tradeoffs are what make it Engineering, not Science.  ;)

- Dave

