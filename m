Return-Path: <linux-kernel-owner+w=401wt.eu-S1766969AbXDEMqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766969AbXDEMqf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 08:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766970AbXDEMqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 08:46:35 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35959 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766969AbXDEMqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 08:46:33 -0400
Subject: Re: [PATCH v3] Stop pmac_zilog from abusing 8250's device numbers;
	optionally.
From: David Woodhouse <dwmw2@infradead.org>
To: Paul Mackerras <paulus@samba.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Brad Boyer <flar@allandria.com>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <17940.14667.503535.507564@cargo.ozlabs.ibm.com>
References: <1175610345.2665.15.camel@shinybook.infradead.org>
	 <17938.57292.870224.132415@cargo.ozlabs.ibm.com>
	 <1175642916.10567.24.camel@shinybook.infradead.org>
	 <20070403212928.GA12951@cynthia.pants.nu>
	 <20070404022544.59b022a6@the-village.bc.nu>
	 <17939.10130.687893.167511@cargo.ozlabs.ibm.com>
	 <1175663999.2932.8.camel@shinybook.infradead.org>
	 <17939.15726.114059.679277@cargo.ozlabs.ibm.com>
	 <1175666635.2932.17.camel@shinybook.infradead.org>
	 <17939.17962.248566.886449@cargo.ozlabs.ibm.com>
	 <1175696383.2774.24.camel@shinybook.infradead.org>
	 <17940.14667.503535.507564@cargo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Thu, 05 Apr 2007 08:45:53 -0400
Message-Id: <1175777154.2719.14.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 (2.10.0-7.fc7.dwmw2.2) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-04-05 at 09:48 +1000, Paul Mackerras wrote:
> David Woodhouse writes:
> 
> > OK, how about a config option to preserve the old behaviour...
> 
> Well, that's a start but it doesn't provide a migration path.
> 
> Is it possible to have the pmac_zilog ports registered both with the
> new number and with the old number (assuming it's not already taken)?
> That way people can move over gradually.

The new option was intended to provide a way to retain the old behaviour
for systems where the kernel is updated but userspace must remain
unchanged (for some reason I can't quite imagine right now).

For _migration_, I think we can handle it better in userspace.

Anyone who builds their own kernel can also manage to change one or two
scripts or configuration files which currently refer to ttyS0. The only
case where the question of migration really holds any water is for
distributions.

In Fedora, pmac_zilog has never worked -- the module always failed to
load because 8250 was built-in. So it's an easy choice there -- we just
switch over and it's fixed.

Other distributions which change over to the fixed behaviour, if they
want 8250 and z8530 ports to co-exist, can provide a udev rule which
creates a symlink from ttySn->ttyPZ0 for backwards compatibility.

Of course, the _numbers_ might change -- a given port might no longer be
ttyS0 but ttyS1. But we're happy to overlook that one even though the
effect on the user is identical, right?

That doesn't address the fact that the 'console=' kernel command line
argument needs changes. But in general, users who are that non-technical
don't use serial consoles, and those who do can cope with this.

I think perhaps we should add this new config option to the
feature-removal-schedule right now, and take it out after a year or so.
That should be plenty of time for people to upgrade.

-- 
dwmw2

