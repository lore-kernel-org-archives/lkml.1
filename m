Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708Ab0BVFoP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 00:44:15 -0500
Received: from forum.psychotherapie.org ([217.160.22.205]:57260 "EHLO
	s15216962.onlinehome-server.info" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751411Ab0BVFoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 00:44:14 -0500
Message-ID: <4B82197F.4050902@metux.de>
Date: Mon, 22 Feb 2010 06:43:27 +0100
From: Enrico Weigelt <weigelt@metux.de>
Organization: metux IT service
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.23) Gecko/20091124 SeaMonkey/1.1.18
MIME-Version: 1.0
CC: linux-kernel@vger.kernel.org
Subject: Re: Dynamic linking in the kernel
References: <4B802870.5030201@metux.de> <20100220.125758.174837163.davem@davemloft.net>
In-Reply-To: <20100220.125758.174837163.davem@davemloft.net>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:

> In order to implement this the kernel would have to also save a copy
> of all pieces of the processes's environment and compare all of the
> environment variable settings on every execution.  This would be
> needed to handle things like LD_PRELOAD, LD_LIBRARY_PATH, and LD_DEBUG
> as just three examples.

Fairly simple:

* parsed per-module data is cached by its inode id
* cached data that can be influenced by LD_PRELOAD/LD_LIBRARY_PATH
  (eg. mapping of library names to actual filenames or inode-id's)
  is cached on hash of these variables plus inode-id

> What's more, any filesystem change involved in the shared libraries,
> the executable, or the dynamic linker would have to be monitored as
> well.

What could go wrong ?

a) overwring an currently mapped-in library. this also applies to
   the traditional approach as well. write-locking (w/o locking
   against removal, of course ;-)) might help.
b) filesystems could get remounted while modules are already cached:
   that (IMHO) changes the inode-id's as well, so not affecting the
   inode-id based cache lookups
c) permissions could get changed: either use the inode data we can on
   the file lookups (we most likely wont get rid of) or use inotify.

> Really, this is not a good idea, and the cost is only ~3 system calls
> per shared library and considering the amount of flexibility we get in
> return it's not that bad at all.

It's worth much more than that:

a) able to cache much data that now have to be parsed/computed on
   each single exec (eg. dependencies, symbol tables, etc)
b) sharing pages even when mmap() is not available


cu
-- 
----------------------------------------------------------------------
 Enrico Weigelt, metux IT service -- http://www.metux.de/

 cellphone: +49 174 7066481   email: info@metux.de   skype: nekrad666
----------------------------------------------------------------------
 Embedded-Linux / Portierung / Opensource-QM / Verteilte Systeme
----------------------------------------------------------------------

