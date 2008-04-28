Return-Path: <linux-kernel-owner+w=401wt.eu-S1752255AbYD1Apz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255AbYD1Apz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 20:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759801AbYD1Aph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 20:45:37 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60831
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758620AbYD1Apg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 20:45:36 -0400
Date: Sun, 27 Apr 2008 17:45:36 -0700 (PDT)
Message-Id: <20080427.174536.62560212.davem@davemloft.net>
To: linux-kernel@vger.kernel.org
Subject: Kconfig 'depend' vs. 'select'
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I'm trying to stir up interest in solving a problem that seems to pop
up frequently. :)

The short story is:

1) If you say your driver "depend"s on a subsystem providing a set of
   interfaces you need, this doesn't work properly if your driver is
   marked built-in and that subsystem you need is modular for some
   reason.

2) If you say "select" on some subsystem, to try and solve the
   conflict in #1, that doesn't take care of any dependencies the
   subsystem may have.  This can also break the build.

There should be an elegant solution to this problem.  But I don't
think changing how 'select' or 'depend' works is it.

'depend' as it stands now works fine for purely boolean things like
"this architecture has or wants FOO".  There is no reason to remove
it or change it's semantics, I think.

So my initial suggestion is a new construct, that is like 'depend' but
takes care about the modular'ness.

It would scan all things depending upon a given target, and make sure
that most strict requirement of built-in vs. modular is adhered to.

So if you had, for example:

config FOO_API
	...

and then you had two drivers:

config DRIVER1
	tristate ...
	needs FOO_API

config DRIVER2
	tristate ...
	needs FOO_API

and DRIVER1 was built modular but DRIVER2 was built-in,
the Kconfig system would make sure FOO_API were built-in.

The "needs" name and syntax is just something arbitrary I came up
with, don't take it too seriously :-)

