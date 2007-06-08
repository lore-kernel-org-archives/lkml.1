Return-Path: <linux-kernel-owner+w=401wt.eu-S1030521AbXFHOOt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030521AbXFHOOt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 10:14:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967935AbXFHOOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 10:14:42 -0400
Received: from lazybastard.de ([212.112.238.170]:52415 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967089AbXFHOOl (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 10:14:41 -0400
Date: Fri, 8 Jun 2007 15:10:09 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Christoph Hellwig <hch@infradead.org>, Jared Hulbert <jaredeh@gmail.com>,
       carsteno@de.ibm.com, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       richard.griffiths@windriver.com,
       Richard Griffiths <res07ml0@verizon.net>, Linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.21] cramfs: add cramfs Linear XIP
Message-ID: <20070608131009.GA20718@lazybastard.org>
References: <46612D6F.6000002@yahoo.com.au> <46641472.3080802@de.ibm.com> <6934efce0706060413y6e74512s19d5f468106d4b85@mail.gmail.com> <20070606113351.GA11701@infradead.org> <6934efce0706060907n209fe6bcnb470101196aa9c55@mail.gmail.com> <20070606161621.GA20247@infradead.org> <6934efce0706061126n551cccaeg68a0def87457911@mail.gmail.com> <20070607193707.GA17144@infradead.org> <6934efce0706071411y6d184629i5ce0694175bef164@mail.gmail.com> <20070607211519.GA22348@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070607211519.GA22348@infradead.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 June 2007 22:15:19 +0100, Christoph Hellwig wrote:
> 
> With the filemap_xip.c helpers adding xip support to any filesystem
> is pretty trivial for the highlevel filesystem operations.  The only
> interesting bit is the lowlevel code (the get_xip_page method and
> the others Carsten mentioned), but we need to do these lowlevel
> code in a generic and proper way anyway.
> 
> I'll try to hack up an xip prototype for jffs2 next week.

I'd absolutely love to see this code!  However, it may be a little
harder than you think.

XIP is basically limited to NOR flash.  And the NOR interface is to
simply map all flash to some physical memory area and interpret
reads/writes to/from this area in a special way.  Internally the flash
chip is implementing a state machine that is controlled by writes and
defines the data read.

Easiest case: read_array state.  In this state, every address will
return the flash content associated to that address on read.  Pretty
much any write will cause a transition to a different state, though.
Any state other than read_array will return flash registers on any read.

In other words, writing to flash prohibits XIP, at least temporarily.  A
read-write xip flash filesystem needs to tear down any xip mapping
before writing and have the flash chip return to read_array mode before
setting up a new mapping.

If the underlying device consists of several chips or of chips that
implement seperate state machines for different areas of the chip (some
Intel chips), only mappings belonging to the chip/area currently being
written are affected.  That should make quite a nice optimizations,
although it can be ignored for a first shot.

Jörn

-- 
Joern's library part 12:
http://physics.nist.gov/cuu/Units/binary.html
