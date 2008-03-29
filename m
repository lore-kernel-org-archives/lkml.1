Return-Path: <linux-kernel-owner+w=401wt.eu-S1753979AbYC2QGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979AbYC2QGi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 12:06:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752200AbYC2QG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 12:06:29 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:56799 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbYC2QG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 12:06:28 -0400
Subject: Re: [PATCH RFC] hotplug-memory: refactor online_pages to separate
	zone growth from page onlining
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Christoph Lameter <clameter@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <47EDA4B9.6030801@goop.org>
References: <47ED8685.9040409@goop.org>
	 <1206751622.27091.20.camel@nimitz.home.sr71.net>
	 <47EDA4B9.6030801@goop.org>
Content-Type: text/plain
Date: Sat, 29 Mar 2008 09:06:14 -0700
Message-Id: <1206806774.31896.27.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-03-28 at 19:08 -0700, Jeremy Fitzhardinge wrote:
> My big remaining problem is how to disable the sysfs interface for this 
> memory.  I need to prevent any onlining via /sys/device/system/memory.

I've been thinking about this some more, and I wish that you wouldn't
just throw this interface away or completely disable it.  It actually
does *exactly* what you want in a way. :)

When the /memoryXX/ directory appears, that means that the hardware has
found the memory, and that the 'struct page' is allocated and ready to
be initialized.

When the OS actually wants to use the memory (initialize the 'struct
page', and free_page() it), it does the 'echo online > /sys...'.  Both
the 'struct page' and the memory represented by it are untouched until
the "online".  This was originally in place to avoid fragmenting it
immediately in the case that the system did not need it.

To me, it sounds like the only different thing that you want is to make
sure that only partial sections are onlined.  So, shall we work with the
existing interfaces to online partial sections, or will we just disable
it entirely when we see Xen?

For Xen and KVM, how does it get decided that the guest needs more
memory?  Is this guest or host driven?  Both?  How is the guest
notified?  Is guest userspace involved at all?

-- Dave

