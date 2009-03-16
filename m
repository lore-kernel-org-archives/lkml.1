Return-Path: <linux-kernel-owner+w=401wt.eu-S1756863AbZCPLmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863AbZCPLmy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 07:42:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751744AbZCPLmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 07:42:44 -0400
Received: from smtp114.mail.mud.yahoo.com ([209.191.84.67]:46875 "HELO
	smtp114.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751333AbZCPLmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 07:42:43 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=KJ3PH8AgkVeOj7BFAHJN1IWtNkTKwaVPw83WNGd2saWSA4kYJuD2kg1A4kWxTxveQg3iNmsf5VhywSePmn1mSicUij/KRDpaGnqnIUA7gt+NDregQcfwq3mD/XJiBH1cWGWc6qawP1ishJcblNaeunZ7M7ggo6iCs8SKHBvIx9Y=  ;
X-YMail-OSG: 4nE31xQVM1mC0sTp0RwmAVKGA1VKCRgV.zZ7W83EK5A7W6FCevlweeE1jDGA6Vfq9ar2hVJO82jLzxaPQTNuQ6lbQ70kfwZDxYWtO5Q.2HD2Y9QrWHRWRkXNpRAimUrjaRI6rM7baJzvhTWMso1doAYV79k9n4ZVBWl9N309dKek6R7nfCq3pp0fIPR2_iYdcwhEvdUijnLMJbihEY5mgXJl
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 20/35] Use a pre-calculated value for num_online_nodes()
Date: Mon, 16 Mar 2009 22:42:34 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>
References: <1237196790-7268-1-git-send-email-mel@csn.ul.ie> <1237196790-7268-21-git-send-email-mel@csn.ul.ie>
In-Reply-To: <1237196790-7268-21-git-send-email-mel@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903162242.35341.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 March 2009 20:46:15 Mel Gorman wrote:
> num_online_nodes() is called by the page allocator to decide whether the
> zonelist needs to be filtered based on cpusets or the zonelist cache.
> This is actually a heavy function and touches a number of cache lines.
> This patch stores the number of online nodes at boot time and when
> nodes get onlined and offlined.
>
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> ---
>  include/linux/nodemask.h |   16 ++++++++++++++--
>  mm/page_alloc.c          |    6 ++++--
>  2 files changed, 18 insertions(+), 4 deletions(-)
>
> diff --git a/include/linux/nodemask.h b/include/linux/nodemask.h
> index 848025c..4749e30 100644
> --- a/include/linux/nodemask.h
> +++ b/include/linux/nodemask.h
> @@ -449,13 +449,25 @@ static inline int num_node_state(enum node_states
> state) node;					\
>  })
>
> +/* Recorded value for num_online_nodes() */
> +extern int static_num_online_nodes;

__read_mostly, please. Check this for any other place you've added
global cachelines that are referenced by the allocator.

