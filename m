Return-Path: <linux-kernel-owner+w=401wt.eu-S1754859AbYKEVFV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859AbYKEVFV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 16:05:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751115AbYKEVFH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 16:05:07 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:42528 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751081AbYKEVFG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 16:05:06 -0500
Subject: Re: [PATCH] [REPOST #2] mm: show node to memory section
	relationship with symlinks in sysfs
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gary Hade <garyhade@us.ibm.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, y-goto@jp.fujitsu.com, pbadari@us.ibm.com,
       mel@csn.ul.ie, lcm@us.ibm.com, mingo@elte.hu, greg@kroah.com,
       nish.aravamudan@gmail.com
In-Reply-To: <20081105123609.878085be.akpm@linux-foundation.org>
References: <20081103234808.GA13716@us.ibm.com>
	 <20081105123609.878085be.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 05 Nov 2008 13:03:44 -0800
Message-Id: <1225919024.11514.4.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-11-05 at 12:36 -0800, Andrew Morton wrote:
> Dumb question: why do this with a symlink forest instead of, say, cat
> /proc/sys/vm/mem-sections?

The basic problem is that we on/offline memory based on sections and not
nodes.  But, physically, people care about nodes.

So, the question we're answering is "to which sections does this node's
memory belong?".  We could just put all this data in one big file and
have:

$ cat /proc/sys/vm/mem-sections?
node: section numbers
0: 1 2 3 4 5
1: 5 6 7 8
2: 99 100 101 102

But, we have the nodes in sysfs and we also have the sections in sysfs
and I don't want Greg to be mean to me.  He's scary.  We could simply
dump the section numbers in sysfs, but the first thing userspace is
going to do is:

for section in /sys/devices/system/node/node1/memory*; do
	nr=$(cat $section)
	cat foo > /sys/devices/system/memory/memory$nr/bar
done

Making the symlinks makes it harder for us to screw this process up,
both in the kernel and in userspace.  Plus, symlinks are easy to code up
in sysfs. 

-- Dave

