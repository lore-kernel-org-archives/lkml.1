Return-Path: <linux-kernel-owner+w=401wt.eu-S1760186AbYEFITb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760186AbYEFITb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 04:19:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755216AbYEFITR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 04:19:17 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:50375 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203AbYEFITO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 04:19:14 -0400
Date: Tue, 6 May 2008 10:19:13 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Sam Ravnborg <sam@ravnborg.org>
cc: Roman Zippel <zippel@linux-m68k.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: kconfig - a suggestion how to fix the select issue
In-Reply-To: <20080504071041.GA15315@uranus.ravnborg.org>
Message-ID: <alpine.LNX.1.10.0805042004310.11757@fbirervta.pbzchgretzou.qr>
References: <20080504071041.GA15315@uranus.ravnborg.org>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 2008-05-04 09:10, Sam Ravnborg wrote:

>Today we have two ways to express/solve dependencies.
>
>Top-down we have "depends on"
>and bottom up we have "select".
>
>The "depends on" dependencies at the same time impact the visibility of 
>a symbol. A symbol with "depends on" not satisfied are not visible and 
>thus not shown in menuconfig.
>
>The "select" method is a way to forcefully set the selected symbol to 
>the same value as the one where the select are stated.
>
>But this has shortcoming in relation to the interface we like to 
>present to the user.
[...]

Suggestion:

Make kconfig work like an interactive package manager. All objects are 
visible and the user can select any of them.

depends and selects are resolved upon request only, i.e. when the user 
hits Exit or manually initiates a resolve request. Kconfig then checks 
to see if all dependencies are satisfied, and if it cannot automatically 
solve it — because it encounters an alternation expression (a || foo) — 
it asks the user to select one.

If user input is not available, exit with error (much like `make 
oldconfig </dev/null` already does on new options.)

Drawback:

Most likely a lot of work.


Consider/Suggested syntax:

	menuconfig V4L2
		tristate "video and all that"
	
	if V4L2
	
	config MY_CAMERA
		tristate "nice cam"
		requires USB || FIREWIRE
	
	endif

leading to a new screen on dependency resolution (when USB=n && 
FIREWIRE=n), showing a modified "choice" prompt where you can 
either
1) change the state of CONFIG_MY_CAMERA to y/m/n.
2) select one of the required dependencies.

	CONFIG_MY_CAMERA has unsatisfied dependencies.

	<M> nice cam
	    ( ) USB
	    ( ) FireWire

Of course a bit of thinking on how to display things is needed for more 
complex requires.
