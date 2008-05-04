Return-Path: <linux-kernel-owner+w=401wt.eu-S1754898AbYEDHKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898AbYEDHKn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 03:10:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752262AbYEDHK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 03:10:28 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:51284 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754333AbYEDHKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 03:10:06 -0400
Date: Sun, 4 May 2008 09:10:41 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Roman Zippel <zippel@linux-m68k.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: kconfig - a suggestion how to fix the select issue
Message-ID: <20080504071041.GA15315@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today we have two ways to express/solve dependencies.

Top-down we have "depends on"
and bottom up we have "select".

The "depends on" dependencies at the same
time impact the visibility of a symbol.
A symbol with "depends on" not satisfied are not
visible and thus not shown in menuconfig.

The "select" method is a way to forcefully
set the selected symbol to the same value
as the one where the select are stated.

But this has shortcoming in relation to the
interface we like to present to the user.

Consider following example:

config A
	bool "a"

config B
	bool "b"
	depends on A

config C
	bool "c"
	depends on B

To be able to chose 'C' I have to chose
A and then B before I am even offered 
the possibility to chose 'C'.
And this is often less than obvious. C could
be a device that uses either USB or firewire
and I could not care less.

The usual way to solve this is to introduce
use of select like this:

config A
	bool "a"

config B
	bool "b"
	depends on A

config C
	bool "c"
	select B     <= use of select

With this change we have increased visibility
of C so it is shown in menuconfig.
But if we chose 'C' then we implicitly set
B='y' too but ignore the dependency of 'A' so
we end up with a configuration where:
A='n'
B='y'
C='y'
which is not what we wanted. As B depends on A we should
never see B equals 'y' when A equals 'n'.

The solution is not to let "select follow dependencies"
as the dependency on B could be complex (A || FOO).
Because we would not know if we should enable A or FOO.

So we need some other way to say the C require B.

The suggestion is to introduce a "require" term used
like this:

config A
        bool "a"

config B
        bool "b"
        depends on A

config C
        bool "c"
        require B

The require dependency will have impact on visibility.
C shall only be visible if all symbols it require are
visible. Note that visible does not imply 'chosen'.
In this case C would be visible when A is chosen.

When the user then choose C and B is not chosen 
then the user is prompted to choose B.

So user has to chose B in order to have C chosen.

This would make it visible for the user that choosing
a camera had the side-effect that USB had to be enabled too.
But if we have some general option that prevents the
visibility of USB we would not be offered the camara
in the first place

Comments?

	Sam



