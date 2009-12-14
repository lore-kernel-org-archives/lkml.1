Return-Path: <linux-kernel-owner+w=401wt.eu-S1757378AbZLNORj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757378AbZLNORj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 09:17:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757354AbZLNORi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 09:17:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57309 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757352AbZLNORh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 09:17:37 -0500
Message-ID: <4B2648E6.4050603@redhat.com>
Date: Mon, 14 Dec 2009 09:17:10 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Jonathan Nieder <jrnieder@gmail.com>
CC: linux-kernel@vger.kernel.org, Jim Keniston <jkenisto@us.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org
Subject: Re: [PATCH] x86: Fix kprobes build with non-gawk awk
References: <20091213220437.GA27718@progeny.tock>
In-Reply-To: <20091213220437.GA27718@progeny.tock>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jonathan,

Jonathan Nieder wrote:
> The instruction attribute table generator fails when run by mawk
> or original-awk:
> 
>  $ mawk -f arch/x86/tools/gen-insn-attr-x86.awk \
> 	arch/x86/lib/x86-opcode-map.txt > /dev/null
>  Semantic error at 240: Second IMM error
>  $ echo $?
>  1
> 
> Line 240 contains "c8: ENTER Iw,Ib", which indicates that this
> instruction has two immediate operands, the second of which is
> one byte.  The script loops through the immediate operands using
> a for loop.
> 
> Unfortunately, there is no guarantee in awk that a for (variable
> in array) loop will return the indices in increasing order.
> Internally, both original-awk and mawk iterate over a hash table
> for this purpose, and both implementations happen to produce the
> index 2 before 1.  The supposed second immediate operand is more
> than one byte wide, producing the error.

Oh, I see.

> 
> So loop over the indices in increasing order instead.  As a
> side-effect, with mawk this means the silly two-entry hash table
> never has to be built.

Thank you for fixing it!

Acked-by: Masami Hiramatsu <mhiramat@redhat.com>

> 
> Cc: Masami Hiramatsu <mhiramat@redhat.com>
> Cc: Jim Keniston <jkenisto@us.ibm.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: x86@kernel.org
> Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
> ---
>  arch/x86/tools/gen-insn-attr-x86.awk |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/tools/gen-insn-attr-x86.awk b/arch/x86/tools/gen-insn-attr-x86.awk
> index e34e92a..7a68506 100644
> --- a/arch/x86/tools/gen-insn-attr-x86.awk
> +++ b/arch/x86/tools/gen-insn-attr-x86.awk
> @@ -226,12 +226,12 @@ function add_flags(old,new) {
>  }
>  
>  # convert operands to flags.
> -function convert_operands(opnd,       i,imm,mod)
> +function convert_operands(count,opnd,       i,j,imm,mod)
>  {
>  	imm = null
>  	mod = null
> -	for (i in opnd) {
> -		i  = opnd[i]
> +	for (j = 1; j <= count; j++) {
> +		i = opnd[j]
>  		if (match(i, imm_expr) == 1) {
>  			if (!imm_flag[i])
>  				semantic_error("Unknown imm opnd: " i)
> @@ -282,8 +282,8 @@ function convert_operands(opnd,       i,imm,mod)
>  		# parse one opcode
>  		if (match($i, opnd_expr)) {
>  			opnd = $i
> -			split($(i++), opnds, ",")
> -			flags = convert_operands(opnds)
> +			count = split($(i++), opnds, ",")
> +			flags = convert_operands(count, opnds)
>  		}
>  		if (match($i, ext_expr))
>  			ext = $(i++)

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

