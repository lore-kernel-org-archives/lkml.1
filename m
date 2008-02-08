Return-Path: <linux-kernel-owner+w=401wt.eu-S1758823AbYBHWZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758823AbYBHWZy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 17:25:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753029AbYBHWZo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 17:25:44 -0500
Received: from jurassic.park.msu.ru ([195.208.223.243]:54247 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753017AbYBHWZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 17:25:43 -0500
Date: Sat, 9 Feb 2008 01:25:44 +0300
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Adrian Bunk <bunk@kernel.org>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>, rusty@rustcorp.com.au,
       LKML <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [BUILD_FAILURE] 2.6.24-git18 build fails section type conflict
	psmouse-base
Message-ID: <20080208222544.GA15333@jurassic.park.msu.ru>
References: <47AC2FDB.7080104@linux.vnet.ibm.com> <20080208104851.GI7198@cs181133002.pp.htv.fi> <47AC502C.70809@linux.vnet.ibm.com> <20080208133022.GA2254@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080208133022.GA2254@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2008 at 03:30:22PM +0200, Adrian Bunk wrote:
> > > On Fri, Feb 08, 2008 at 04:02:59PM +0530, Kamalesh Babulal wrote:
> > >> The 2.6.24-git18 kernel build fails on the power machine with following message
> > >> drivers/input/mouse/psmouse-base.c:44: error: __param_proto causes a section type conflict

My fault - I somehow overlooked that ppc64 is the club member...

> The comment is wrong now, the #if's should refer to kconfig variables, 
> and I don't know whether this patch is really the best solution.

I think it's the best, because it at least points at some of
the problems which arise when you blindly rely on some undocumented
behaviour of __attribute__(section()) on certain platform, and
assume it's the same for the rest of the world...

Alternatives are:
- drop the 'const' qualifier from that macro unconditionally, so that
  __param section gets read/write on all arches. I'd be fine with it,
  but then we'll probably have the same problem again and again...
- make the offending module_param functions global (psmouse and 3-4
  other places). But how do you explain that to driver writers?
  These functions are logically private to this particular module,
  so it's obviously not the same as "we don't export static functions",
  though underlying problem is precisely the same on our three
  platforms...
- hack up gcc. But I don't even have a proposal, because it's not a bug
  from gcc point of view. Ideally, I'd like to pass some extra parameters
  to __attribute__(section()), like r/w control and some equivalent of
  -fno-jump-tables...

Oh, well. Updated patch in a minute.

Ivan.
