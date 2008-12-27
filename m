Return-Path: <linux-kernel-owner+w=401wt.eu-S1753199AbYL0B40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199AbYL0B40 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 20:56:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752372AbYL0B4O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 20:56:14 -0500
Received: from relais.videotron.ca ([24.201.245.36]:48661 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185AbYL0B4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 20:56:13 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Fri, 26 Dec 2008 20:56:07 -0500 (EST)
From: Nicolas Pitre <nico@cam.org>
X-X-Sender: nico@xanadu.home
To: Heikki Orsila <shdl@zakalwe.fi>
Cc: Junio C Hamano <gitster@pobox.com>, git@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] GIT 1.6.1
In-reply-to: <20081225114443.GD6115@zakalwe.fi>
Message-id: <alpine.LFD.2.00.0812262025320.30266@xanadu.home>
References: <7v7i5odams.fsf@gitster.siamese.dyndns.org>
 <20081225114443.GD6115@zakalwe.fi>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Dec 2008, Heikki Orsila wrote:

> On Wed, Dec 24, 2008 at 10:36:27PM -0800, Junio C Hamano wrote:
> > * The packfile machinery hopefully is more robust when dealing with
> >   corrupt packs if redundant objects involved in the corruption are
> >   available elsewhere.
> 
> Has anyone written a summary of how Git's redundancy operates?
> 
> * What would be the probability for a single bit flip to corrupt the 
> repository?

This is not something that git itself could answer.  The probability 
depends on the quality of your hardware.  Once that probability has 
occurred though, it is clear that your repository is then corrupted as 
there is hardly any redundant bits in a git repository.

> * And what is the situation where a single bit flip can not corrupt the 
> database?

The database can be resilient against most kind of corruptions if you 
have a redundant copy of the affected object.  It will still be 
corrupted, but git is now able to detect corruptions gracefully and 
function correctly with some fallback objects.  Those objects must exist 
in some other related repository though, and copied over to the affected 
repository manually. It's then possible and recommended to "fix" the 
corruption simply by repacking the repository at that point.

So there is no magic involved: you need to have some kind of backups, 
either using traditional backup solutions, or by simply having your 
repository cloned somewhere else.  The idea of having a repository fixed 
with redundant objects is for those cases where you need to salvage new 
work that has no corresponding backup, but although corresponding 
objects are not corrupted, they could be delta objects which base is 
against old objects which happen to be corrupted.

> * When (which commands/functions) is error detection done?

Error detection is performed all the time.  When it's not the more 
expensive SHA1 checksum, at least the zlib CRC32 is verified.  What the 
latest git version does amongst other corruption related things is to 
close some small holes where some specific kind of corruptions could 
have been undetected and propagated from one pack to another when 
repacking.


Nicolas
