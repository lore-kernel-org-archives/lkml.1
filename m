Return-Path: <linux-kernel-owner+w=401wt.eu-S1755860AbZKDMpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860AbZKDMpq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 07:45:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755781AbZKDMpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 07:45:45 -0500
Received: from mga14.intel.com ([143.182.124.37]:23973 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753787AbZKDMpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 07:45:45 -0500
X-ExtLoop1: 1
Date: Wed, 4 Nov 2009 20:18:32 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Alex Chiang <achiang@hp.com>, akpm@linux-foundation.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Andi Kleen <andi@firstfloor.org>, "Li, Haicheng" <haicheng.li@intel.com>
Subject: Re: [PATCH] page-types: decode flags directly from command line
Message-ID: <20091104121832.GB26504@localhost>
References: <20091103225441.GB4087@grease>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091103225441.GB4087@grease>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex,

On Wed, Nov 04, 2009 at 06:54:41AM +0800, Alex Chiang wrote:
> Teach page-types to decode page flags directly from the command
> line.

This is good feature to have - I considered adding it, too ;)

> 
> Why is this useful? For instance, if you're using memory hotplug
> and see this in /var/log/messages:
> 
> 	kernel: removing from LRU failed 3836dd0/1/1e00000000000400
> 
> It would be nice to decode those page flags without staring at
> the source.

In fact it's more than decode - encoding is also possible with the
_same_ code! So maybe "-d" and help message will not be all that
appropriate.

> Example usage and output:
> 
> linux-2.6/Documentation/vm$ ./page-types -d 0x1e00000000000400
>              flags	page-count       MB  symbolic-flags			long-symbolic-flags
> 0x1e00000000000400	         1        0  __________B_______________________buddy
>              total	         1        0

The output is a bit redundant - so does the code. Could you simplify
them a bit?

Thanks,
Fengguang

> Signed-off-by: Alex Chiang <achiang@hp.com>
> ---
>  page-types.c |   26 ++++++++++++++++++++++++--
>  1 file changed, 24 insertions(+), 2 deletions(-)
> ---
> diff --git a/Documentation/vm/page-types.c b/Documentation/vm/page-types.c
> index 3ec4f2a..a55c624 100644
> --- a/Documentation/vm/page-types.c
> +++ b/Documentation/vm/page-types.c
> @@ -674,6 +674,7 @@ static void usage(void)
>  	printf(
>  "page-types [options]\n"
>  "            -r|--raw                  Raw mode, for kernel developers\n"
> +"            -d|--decode  flags        Decode a single page's flags\n"
>  "            -a|--addr    addr-spec    Walk a range of pages\n"
>  "            -b|--bits    bits-spec    Walk pages with specified bits\n"
>  "            -p|--pid     pid          Walk process address space\n"
> @@ -682,10 +683,12 @@ static void usage(void)
>  #endif
>  "            -l|--list                 Show page details in ranges\n"
>  "            -L|--list-each            Show page details one by one\n"
> -"            -N|--no-summary           Don't show summay info\n"
> +"            -N|--no-summary           Don't show summary info\n"
>  "            -X|--hwpoison             hwpoison pages\n"
>  "            -x|--unpoison             unpoison pages\n"
>  "            -h|--help                 Show this usage message\n"
> +"flags:\n"
> +"            0x0000000000000400        A single page's flags, e.g.\n"
>  "addr-spec:\n"
>  "            N                         one page at offset N (unit: pages)\n"
>  "            N+M                       pages range from N to N+M-1\n"
> @@ -884,12 +887,28 @@ static void parse_bits_mask(const char *optarg)
>  	add_bits_filter(mask, bits);
>  }
>  
> +static void decode_flags_and_exit(const char *optarg)
> +{
> +	uint64_t flags;
> +
> +	flags = parse_number(optarg);
> +
> +	opt_list = 0;
> +	opt_hwpoison = 0;
> +	opt_unpoison = 0;
> +
> +	add_page(0, 0, flags);
> +	show_summary();
> +
> +	exit(0);
> +}
>  
>  static struct option opts[] = {
>  	{ "raw"       , 0, NULL, 'r' },
>  	{ "pid"       , 1, NULL, 'p' },
>  	{ "file"      , 1, NULL, 'f' },
>  	{ "addr"      , 1, NULL, 'a' },
> +	{ "decode"    , 1, NULL, 'd' },
>  	{ "bits"      , 1, NULL, 'b' },
>  	{ "list"      , 0, NULL, 'l' },
>  	{ "list-each" , 0, NULL, 'L' },
> @@ -907,7 +926,7 @@ int main(int argc, char *argv[])
>  	page_size = getpagesize();
>  
>  	while ((c = getopt_long(argc, argv,
> -				"rp:f:a:b:lLNXxh", opts, NULL)) != -1) {
> +				"rp:f:a:b:d:lLNXxh", opts, NULL)) != -1) {
>  		switch (c) {
>  		case 'r':
>  			opt_raw = 1;
> @@ -924,6 +943,9 @@ int main(int argc, char *argv[])
>  		case 'b':
>  			parse_bits_mask(optarg);
>  			break;
> +		case 'd':
> +			decode_flags_and_exit(optarg);
> +			break;
>  		case 'l':
>  			opt_list = 1;
>  			break;
