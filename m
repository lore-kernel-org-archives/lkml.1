Return-Path: <linux-kernel-owner+w=401wt.eu-S1753468AbXLIXWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468AbXLIXWv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 18:22:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751170AbXLIXWn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 18:22:43 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:58167 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbXLIXWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 18:22:42 -0500
To: Arnd Bergmann <arnd@arndb.de>
Cc: linuxppc-dev@ozlabs.org, Joachim Fenkes <fenkes@de.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, OF-EWG <ewg@lists.openfabrics.org>,
       Christoph Raisch <raisch@de.ibm.com>, Marcus Eder <meder@de.ibm.com>,
       OF-General <general@lists.openfabrics.org>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
Subject: Re: [PATCH] IB/ehca: Serialize HCA-related hCalls on POWER5
X-Message-Flag: Warning: May contain useful information
References: <200712061607.20004.fenkes@de.ibm.com>
	<200712061648.24806.arnd@arndb.de> <ada7ijrd6gy.fsf@cisco.com>
	<200712071058.38416.arnd@arndb.de>
From: Roland Dreier <rdreier@cisco.com>
Date: Sun, 09 Dec 2007 15:22:39 -0800
In-Reply-To: <200712071058.38416.arnd@arndb.de> (Arnd Bergmann's message of "Fri, 7 Dec 2007 10:58:37 +0100")
Message-ID: <adaodcza1xc.fsf@cisco.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.4.20 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 09 Dec 2007 23:22:40.0092 (UTC) FILETIME=[644969C0:01C83ABA]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > I think it needs some more inspection. The msleep in there is only called
 > for hcalls that return H_IS_LONG_BUSY(). In theory, you can call
 > ehca_plpar_hcall_norets() from inside an interrupt handler if the
 > hcall in question never returns long busy.

Fair enough... according to Documentation/infiniband/core_locking.txt,
the only driver methods that cannot sleep are:

    create_ah
    modify_ah
    query_ah
    destroy_ah
    bind_mw
    post_send
    post_recv
    poll_cq
    req_notify_cq
    map_phys_fmr

and I don't think ehca does an hcall from any of those.  Of course
there might be other driver-internal code paths that I don't know
about.  Maybe do a quick audit and then stick might_sleep() in the
hcall functions to catch any mistakes?

 - R.
