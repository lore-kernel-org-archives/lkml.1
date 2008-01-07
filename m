Return-Path: <linux-kernel-owner+w=401wt.eu-S1755555AbYAGTcl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555AbYAGTcl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 14:32:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752319AbYAGTce
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 14:32:34 -0500
Received: from mx1.redhat.com ([66.187.233.31]:41814 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517AbYAGTcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 14:32:33 -0500
Date: Mon, 7 Jan 2008 14:32:17 -0500
From: Rik van Riel <riel@redhat.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Eric Whitney <eric.whitney@hp.com>,
       Nick Dokos <nicholas.dokos@hp.com>
Subject: Re: [patch 00/19] VM pageout scalability improvements
Message-ID: <20080107143217.11b0fce1@bree.surriel.com>
In-Reply-To: <Pine.LNX.4.64.0801071107440.23617@schroedinger.engr.sgi.com>
References: <20080102224144.885671949@redhat.com>
	<1199379128.5295.21.camel@localhost>
	<20080103120000.1768f220@cuia.boston.redhat.com>
	<1199380412.5295.29.camel@localhost>
	<20080103170035.105d22c8@cuia.boston.redhat.com>
	<1199463934.5290.20.camel@localhost>
	<p73d4sh8s93.fsf@bingen.suse.de>
	<1199466372.5290.37.camel@localhost>
	<Pine.LNX.4.64.0801071107440.23617@schroedinger.engr.sgi.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jan 2008 11:07:54 -0800 (PST)
Christoph Lameter <clameter@sgi.com> wrote:
> On Fri, 4 Jan 2008, Lee Schermerhorn wrote:
> 
> > We see this on both NUMA and non-NUMA. x86_64 and ia64.  The basic
> > criteria to reproduce is to be able to run thousands [or low 10s of
> > thousands] of tasks, continually increasing the number until the system
> > just goes into reclaim.  Instead of swapping, the system seems to
> > hang--unresponsive from the console, but with "soft lockup" messages
> > spitting out every few seconds...
> 
> Ditto here.

I have some suspicions on what could be causing this.

The most obvious suspect is get_scan_ratio() continuing to return
100 file reclaim, 0 anon reclaim when the file LRUs have already
been reduced to something very small, because reclaiming up to that
point was easy.

I plan to add some code to automatically set the anon reclaim to
100% if (free + file_active + file_inactive <= zone->pages_high),
meaning that reclaiming just file pages will not be able to free
enough pages.

-- 
All rights reversed.
