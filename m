Return-Path: <linux-kernel-owner+w=401wt.eu-S1754747AbXLJVrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747AbXLJVrt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 16:47:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751214AbXLJVrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 16:47:40 -0500
Received: from sj-iport-3-in.cisco.com ([171.71.176.72]:64083 "EHLO
	sj-iport-3.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198AbXLJVrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 16:47:39 -0500
To: Joachim Fenkes <fenkes@de.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linuxppc-dev@ozlabs.org,
       LKML <linux-kernel@vger.kernel.org>, OF-EWG <ewg@lists.openfabrics.org>,
       Christoph Raisch <raisch@de.ibm.com>, Marcus Eder <meder@de.ibm.com>,
       OF-General <general@lists.openfabrics.org>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
Subject: Re: [PATCH] IB/ehca: Serialize HCA-related hCalls on POWER5
X-Message-Flag: Warning: May contain useful information
References: <200712061607.20004.fenkes@de.ibm.com>
	<200712071058.38416.arnd@arndb.de> <adaodcza1xc.fsf@cisco.com>
	<200712101841.30010.fenkes@de.ibm.com>
From: Roland Dreier <rdreier@cisco.com>
Date: Mon, 10 Dec 2007 13:47:37 -0800
In-Reply-To: <200712101841.30010.fenkes@de.ibm.com> (Joachim Fenkes's message of "Mon, 10 Dec 2007 18:41:29 +0100")
Message-ID: <adahciq9q86.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 10 Dec 2007 21:47:38.0200 (UTC) FILETIME=[481B7D80:01C83B76]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > >     map_phys_fmr
 > 
 > In fact, we do use hCalls there. Our hardware doesn't actually support FMRs,
 > so we translate a "map FMR" into a "reallocate PMR", which doesn't work
 > without hCalls. What's more, the hCalls involved (e.g. H_FREE_RESOURCE)
 > might well return H_LONG_BUSY, so the whole operation might sleep; no way
 > around it.

It's a big problem.  If you cannot implement FMRs in such a way that
you can handling having map_phys_fmr being called in a context that
can't sleep, then I think the only option is to remove your FMR
support.  It's an optional device feature, so this should be OK
(although the iSER driver currently seems to depend on a device
supporting FMRs, which is probably going to be a problem with iWARP
support in the future anyway).

The fact that consumers can map FMRs from interrupt context, while
holding locks, etc, is pretty fundamental to the use of FMRs so I
don't see any way around the requirement that map_phys_fmr never
sleep.

 - R.
