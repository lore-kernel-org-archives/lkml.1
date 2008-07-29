Return-Path: <linux-kernel-owner+w=401wt.eu-S1755169AbYG2HgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169AbYG2HgW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 03:36:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753013AbYG2HgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 03:36:14 -0400
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:37056 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943AbYG2HgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 03:36:13 -0400
Date: Tue, 29 Jul 2008 09:36:11 +0200
From: Bastian Blank <waldi@debian.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linuxppc-dev@ozlabs.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc/lpar - defer prefered console setup
Message-ID: <20080729073611.GA30627@wavehammer.waldi.eu.org>
Mail-Followup-To: Bastian Blank <waldi@debian.org>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	linuxppc-dev@ozlabs.org, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org
References: <20080728185651.GA29530@wavehammer.waldi.eu.org> <1217300778.11188.233.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1217300778.11188.233.camel@pasglop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2008 at 01:06:18PM +1000, Benjamin Herrenschmidt wrote:
> On Mon, 2008-07-28 at 20:56 +0200, Bastian Blank wrote:
> > Hi
> > 
> > The powerpc lpar code adds a prefered console at a very early state,
> > during arch_setup. This runs even before the console setup from the
> > command line and takes preference.
> > 
> > This patch moves the prefered console setup into an arch_initcall which
> > runs later and allows the specification of the correct console on the
> > command line. The udbg console remains as boot console.
> > 
> Shouldn't it be a console_initcall() ? 

No. console_initcall is for the initial console setup and runs way long
before the command line setup. It needs to run after that.

> > There is a different problem that the code does not pick up the correct
> > console because it uses a part (4) of the lpar device number (30000004)
> > instead of the correct index 1.
> Now, regarding the "different problem" I think it's even worse than
> that, looking at the code there's some non sensical things in here...
> 
> add_preferred_console() argument is what gets compared to
> console->index, right ? Now if you look at hvc_instantiate(),
> it compares each "index" argument passed in to hvc_con_driver.index,
> and that index argument passed from hvc_find_vtys() has strictly
> nothing to do with the vtermno, it's purely the index of the node
> found in order...
> 
> So I think the whole stuff is non-sensical and needs fixing. 

Yep. Would it be a solution to check this in hvc_vio and hvsi and do the
calls there? They now that the device is available and the correct
index. But even then it have to run after the command line. (Or the
console infrastructure fixed to support more then one device of a type.)

Bastian

-- 
Peace was the way.
		-- Kirk, "The City on the Edge of Forever", stardate unknown
