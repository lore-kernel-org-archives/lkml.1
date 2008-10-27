Return-Path: <linux-kernel-owner+w=401wt.eu-S1752041AbYJ0Ny3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041AbYJ0Ny3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 09:54:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750729AbYJ0NyU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 09:54:20 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:39036 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbYJ0NyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 09:54:19 -0400
Message-ID: <4905C7C0.1060301@s5r6.in-berlin.de>
Date: Mon, 27 Oct 2008 14:53:04 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.17) Gecko/20080829 SeaMonkey/1.1.12
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux1394-devel@lists.sourceforge.net, bugme-daemon@bugzilla.kernel.org,
       linux-kernel@vger.kernel.org, Dan Dennedy <dan@dennedy.org>,
       Johannes Weiner <hannes@saeurebad.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [Bug 11824][PATCH] ieee1394: raw1394: fix possible deadlock in
 multithreaded clients
References: <bug-11824-4803@http.bugzilla.kernel.org/> <4902F41E.5070306@s5r6.in-berlin.de> <tkrat.94e673551b87c230@s5r6.in-berlin.de> <20081027101303.GI8116@elte.hu> <4905C40F.8080809@s5r6.in-berlin.de>
In-Reply-To: <4905C40F.8080809@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
> .write() and .mmap() were not serialized against each other and against
> .ioctl() at all in raw1394 before 2.6.28-rc1.

PS:  There is a need for serialization to some degree because the client
registers itself with a controller via .write() (among many other things
that are implemented through .write()), manages isochronous I/O contexts
on this controller via .ioctl() and maps DMA buffers for isochronous I/O
via .mmap().

The raw1394 driver tracks respective state by means of two state
variables and some other variables, and accesses of the state variables
is not reentrant within one opener of /dev/raw1394.  AFAICS the issue
exists between .write() and .write(), and independently of that between
.ioctl() and .ioctl() and between .ioctl() and .mmap().

Local mutex protection is the simplest way to fix that --- except that
there is this obscure issue of locking order between the driver's mutex
and the mmap semaphore outside the driver.
-- 
Stefan Richter
-=====-==--- =-=- ==-=-
http://arcgraph.de/sr/
