Return-Path: <linux-kernel-owner+w=401wt.eu-S1757502AbYJVSsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757502AbYJVSsa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 14:48:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753193AbYJVSsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 14:48:21 -0400
Received: from waste.org ([66.93.16.53]:52414 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752705AbYJVSsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 14:48:20 -0400
Subject: Re: [PATCH,RFC] ext3: Add support for non-native signed/unsigned
	htree hash algorithms
From: Matt Mackall <mpm@selenic.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <1224560624-9691-2-git-send-email-tytso@mit.edu>
References: <1224560624-9691-1-git-send-email-tytso@mit.edu>
	 <1224560624-9691-2-git-send-email-tytso@mit.edu>
Content-Type: text/plain
Date: Wed, 22 Oct 2008 11:30:08 -0500
Message-Id: <1224693008.4323.134.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-10-20 at 23:43 -0400, Theodore Ts'o wrote:
> The original ext3 hash algorithms assumed that variables of type char
> were signed, as God and K&R intended.  Unfortunately, this assumption
> is not true on some architectures.  Userspace support for marking
> filesystems with non-native signed/unsigned chars was added two years
> ago, but the kernel-side support was never added (until now).
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> Cc: akpm@linux-foundation.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  fs/ext3/hash.c             |   42 +++++++++++++++++++++++++++++++++---------
>  fs/ext3/namei.c            |    7 +++++++
>  fs/ext3/super.c            |   15 +++++++++++++++
>  include/linux/ext3_fs.h    |   28 +++++++++++++++++++++++++++-
>  include/linux/ext3_fs_sb.h |    1 +
>  5 files changed, 83 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/ext3/hash.c b/fs/ext3/hash.c
> index c30e149..855eacb 100644
> --- a/fs/ext3/hash.c
> +++ b/fs/ext3/hash.c
> @@ -35,11 +35,20 @@ static void TEA_transform(__u32 buf[4], __u32 const in[])
>  
> 
>  /* The old legacy hash */
> -static __u32 dx_hack_hash (const char *name, int len)
> +static __u32 dx_hack_hash (const char *name, int len, int unsigned_flag)
>  {
> -	__u32 hash0 = 0x12a3fe2d, hash1 = 0x37abe8f9;
> +	__u32 hash, hash0 = 0x12a3fe2d, hash1 = 0x37abe8f9;
> + 	const unsigned char *ucp = (const unsigned char *) name;
> +	const signed char *scp = (const signed char *) name;
> +	int c;
> +
>  	while (len--) {
> -		__u32 hash = hash1 + (hash0 ^ (*name++ * 7152373));
> +		if (unsigned_flag)
> +			c = (int) *ucp++;
> +		else
> +			c = (int) *scp++;

Branch in the inner loop? Space after typecast?

>  	for (i=0; i < len; i++) {
>  		if ((i % 4) == 0)
>  			val = pad;
> -		val = msg[i] + (val << 8);
> +		if (unsigned_flag)
> +			c = (int) ucp[i];
> +		else
> +			c = (int) scp[i];
> +
> +		val = c + (val << 8);

And here.

-- 
Mathematics is the supreme nostalgia of our time.

