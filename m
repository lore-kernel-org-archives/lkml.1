Return-Path: <linux-kernel-owner+w=401wt.eu-S1759721AbZD2TT0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759721AbZD2TT0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 15:19:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757518AbZD2TSw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 15:18:52 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:18407 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756348AbZD2TSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 15:18:51 -0400
Message-ID: <49F8A7D1.6010307@oracle.com>
Date: Wed, 29 Apr 2009 12:17:37 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Jason Baron <jbaron@redhat.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       rostedt@goodmis.org, fweisbec@gmail.com, mathieu.desnoyers@polymtl.ca,
       wcohen@redhat.com
Subject: Re: [PATCH 1/3] make kernel-doc understand TRACE_EVENT() macro
References: <200904291745.n3THjPhO019531@ns3.rdu.redhat.com>
In-Reply-To: <200904291745.n3THjPhO019531@ns3.rdu.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt705.oracle.com [141.146.40.83]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010203.49F8A788.01D4:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason Baron wrote:
> Add support to kernel-doc for tracepoint comments above TRACE_EVENT()
> macro definitions. Paves the way for tracepoint docbook.
> 
> 
> Signed-off-by: Jason Baron <jbaron@redhat.com>
> 
> ---
>  scripts/kernel-doc |   21 +++++++++++++++++++++
>  1 files changed, 21 insertions(+), 0 deletions(-)
> 
> diff --git a/scripts/kernel-doc b/scripts/kernel-doc
> index 0f11870..9d9ab4b 100755
> --- a/scripts/kernel-doc
> +++ b/scripts/kernel-doc
> @@ -1827,6 +1827,24 @@ sub reset_state {
>      $state = 0;
>  }
>  
> +sub tracepoint_munge() {
> +	my $tracepointname = 0;
> +	my $tracepointargs = 0;
> +
> +	if($prototype =~ m/TRACE_EVENT\((.*?),/) {
> +		$tracepointname = $1;
> +	}
> +	if($prototype =~ m/TP_PROTO\((.*?)\)/) {
> +		$tracepointargs = $1;
> +	}
> +	if (($tracepointname eq 0) || ($tracepointargs eq 0)) {
> +		print STDERR "Warning: Unrecognized tracepoint format: \n" .
> +			     "$prototype\n"

I'd prefer for this warning to use the usual kernel-doc warning format, with
file:line information:

		print STDERR "Warning(${file}:$.): Unrecognized ....

Otherwise, looks good.  Thanks.


> +	} else {
> +		$prototype = "static inline void trace_$tracepointname($tracepointargs)";
> +	}
> +}
> +
>  sub syscall_munge() {
>  	my $void = 0;
>  
> @@ -1881,6 +1899,9 @@ sub process_state3_function($$) {
>  	if ($prototype =~ /SYSCALL_DEFINE/) {
>  		syscall_munge();
>  	}
> +	if ($prototype =~ /TRACE_EVENT/) {
> +		tracepoint_munge();
> +	}
>  	dump_function($prototype, $file);
>  	reset_state();
>      }


-- 
~Randy
