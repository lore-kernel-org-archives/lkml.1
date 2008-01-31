Return-Path: <linux-kernel-owner+w=401wt.eu-S933143AbYAaKpm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933143AbYAaKpm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 05:45:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761775AbYAaKpe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 05:45:34 -0500
Received: from styx.suse.cz ([82.119.242.94]:54408 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755641AbYAaKpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 05:45:33 -0500
Date: Thu, 31 Jan 2008 11:45:32 +0100
From: Jan Kara <jack@suse.cz>
To: marcin.slusarz@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/10] udf: fix udf_build_ustr
Message-ID: <20080131104532.GB1461@duck.suse.cz>
References: <1201727040-6769-1-git-send-email-marcin.slusarz@gmail.com> <1201727040-6769-3-git-send-email-marcin.slusarz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201727040-6769-3-git-send-email-marcin.slusarz@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 30-01-08 22:03:52, marcin.slusarz@gmail.com wrote:
> udf_build_ustr was completely broken when
> size >= UDF_NAME_LEN - 1 or size < 2
> 
> nobody noticed because all callers set size
> to acceptable values (constants)
> 
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> Cc: Jan Kara <jack@suse.cz>
> ---
>  fs/udf/unicode.c |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/udf/unicode.c b/fs/udf/unicode.c
> index f969617..f4e54e5 100644
> --- a/fs/udf/unicode.c
> +++ b/fs/udf/unicode.c
> @@ -47,16 +47,16 @@ static int udf_char_to_ustr(struct ustr *dest, const uint8_t *src, int strlen)
>   */
>  int udf_build_ustr(struct ustr *dest, dstring *ptr, int size)
>  {
> -	int usesize;
> +	u8 usesize;
  What is the purpose for this? Why not just leave int there? Arithmetics
is usually best done in ints if that's possible...
>  
> -	if ((!dest) || (!ptr) || (!size))
> +	if (!dest || !ptr || size < 2)
>  		return -1;
>  
> -	memset(dest, 0, sizeof(struct ustr));
> -	usesize = (size > UDF_NAME_LEN) ? UDF_NAME_LEN : size;
> +	usesize = min_t(size_t, size - 2, sizeof(dest->u_name));
>  	dest->u_cmpID = ptr[0];
> -	dest->u_len = ptr[size - 1];
> -	memcpy(dest->u_name, ptr + 1, usesize - 1);
> +	dest->u_len = usesize;
> +	memcpy(dest->u_name, ptr + 1, usesize);
> +	memset(dest->u_name + usesize, 0, sizeof(dest->u_name) - usesize);
  Hmm, after parsing what the standard says (ugh), I don't think the code is
wrong (at least I think you made it incorrect). The caller of
udf_char_to_ustr() specifies length of the field (not length of the
string). Now, in the last character of the field is stored the number of
characters in the string and in the first character of the field is stored
encoding of the string. So the original code seems correct.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
