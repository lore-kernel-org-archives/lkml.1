Return-Path: <linux-kernel-owner+w=401wt.eu-S1756588AbYBDTbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588AbYBDTbV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 14:31:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753719AbYBDTbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 14:31:10 -0500
Received: from styx.suse.cz ([82.119.242.94]:38724 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752780AbYBDTbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 14:31:09 -0500
Date: Mon, 4 Feb 2008 20:31:07 +0100
From: Jan Kara <jack@suse.cz>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/10] udf: fix udf_build_ustr
Message-ID: <20080204193107.GN3426@duck.suse.cz>
References: <1201727040-6769-1-git-send-email-marcin.slusarz@gmail.com> <1201727040-6769-3-git-send-email-marcin.slusarz@gmail.com> <20080131104532.GB1461@duck.suse.cz> <20080131195730.GB6222@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080131195730.GB6222@joi>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 31-01-08 20:57:47, Marcin Slusarz wrote:
> On Thu, Jan 31, 2008 at 11:45:32AM +0100, Jan Kara wrote:
> > On Wed 30-01-08 22:03:52, marcin.slusarz@gmail.com wrote:
> > > udf_build_ustr was completely broken when
> > > size >= UDF_NAME_LEN - 1 or size < 2
> > > 
> > > nobody noticed because all callers set size
> > > to acceptable values (constants)
> > > 
> > > Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> > > Cc: Jan Kara <jack@suse.cz>
> > > ---
> > >  fs/udf/unicode.c |   12 ++++++------
> > >  1 files changed, 6 insertions(+), 6 deletions(-)
> > > 
> > > diff --git a/fs/udf/unicode.c b/fs/udf/unicode.c
> > > index f969617..f4e54e5 100644
> > > --- a/fs/udf/unicode.c
> > > +++ b/fs/udf/unicode.c
> > > @@ -47,16 +47,16 @@ static int udf_char_to_ustr(struct ustr *dest, const uint8_t *src, int strlen)
> > >   */
> > >  int udf_build_ustr(struct ustr *dest, dstring *ptr, int size)
> > >  {
> > > -	int usesize;
> > > +	u8 usesize;
> >   What is the purpose for this? Why not just leave int there? Arithmetics
> > is usually best done in ints if that's possible...
> I made it to stress that length of string fits in one byte.
> (struct ustr->u_len is uint8_t)
  I see. I don't think this is really worthwhile, please keep int there.

> > > -	if ((!dest) || (!ptr) || (!size))
> > > +	if (!dest || !ptr || size < 2)
> > >  		return -1;
> > >  
> > > -	memset(dest, 0, sizeof(struct ustr));
> > > -	usesize = (size > UDF_NAME_LEN) ? UDF_NAME_LEN : size;
> > > +	usesize = min_t(size_t, size - 2, sizeof(dest->u_name));
> > >  	dest->u_cmpID = ptr[0];
> > > -	dest->u_len = ptr[size - 1];
> > > -	memcpy(dest->u_name, ptr + 1, usesize - 1);
> > > +	dest->u_len = usesize;
> > > +	memcpy(dest->u_name, ptr + 1, usesize);
> > > +	memset(dest->u_name + usesize, 0, sizeof(dest->u_name) - usesize);
> >   Hmm, after parsing what the standard says (ugh), I don't think the code is
> > wrong (at least I think you made it incorrect). The caller of
> > udf_char_to_ustr() specifies length of the field (not length of the
> > string). Now, in the last character of the field is stored the number of
> > characters in the string and in the first character of the field is stored
> > encoding of the string. So the original code seems correct.
> You are right. I broke length calculation.
> 
> But observe that:
> - when size == 1:
> 	dest->u_len = ptr[1 - 1], but at ptr[0] there's cmpID,
> 	so we create string with wrong length
  Yes, but that never happens. This function should always be used for
fixed-length strings whose maximum length is defined in the standard so if
someone calls it with size == 1, it is a bug. So you can just do
BUG_ON(size < 2).

> - when size > 1 and size < UDF_NAME_LEN:
> 	we set u_len correctly, but memcpy copies one needless byte
> - when size == UDF_NAME_LEN - 1:
> 	memcpy overwrites u_len - with correct value, but...
  Yes, you're right.

> - when size >= UDF_NAME_LEN:
> 	we copy UDF_NAME_LEN - 1 bytes, but dest->u_name is array
> 	of UDF_NAME_LEN - 2 bytes, so we are overwriting u_len with
> 	character from input string
  Again, this should not happen because UDF_NAME_LEN is large enough but
you are right it's better to clean this.

> So if I didn't mess up someting, correct change would look like this:
> ---
> udf: fix udf_build_ustr
> 
> udf_build_ustr was broken when
> size >= UDF_NAME_LEN or size < 2
> 
> nobody noticed because all callers set size
> to acceptable values (constants whitin range)
> 
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> Cc: Jan Kara <jack@suse.cz>
> ---
>  fs/udf/unicode.c |   13 +++++++------
>  1 files changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/udf/unicode.c b/fs/udf/unicode.c
> index 335fc56..83ae9fc 100644
> --- a/fs/udf/unicode.c
> +++ b/fs/udf/unicode.c
> @@ -47,16 +47,17 @@ static int udf_char_to_ustr(struct ustr *dest, const uint8_t *src, int strlen)
>   */
>  int udf_build_ustr(struct ustr *dest, dstring *ptr, int size)
>  {
> -	int usesize;
> +	u8 usesize;
  Just use int here..

>  
> -	if ((!dest) || (!ptr) || (!size))
> +	if (!dest || !ptr || size < 2)
>  		return -1;
>  
> -	memset(dest, 0, sizeof(struct ustr));
> -	usesize = (size > UDF_NAME_LEN) ? UDF_NAME_LEN : size;
> +	usesize = min_t(size_t, ptr[size - 1], sizeof(dest->u_name));
> +	usesize = min_t(size_t, usesize, size - 2);
  And here use just min() in both cases so that it's easier to read.

>  	dest->u_cmpID = ptr[0];
> -	dest->u_len = ptr[size - 1];
> -	memcpy(dest->u_name, ptr + 1, usesize - 1);
> +	dest->u_len = usesize;
> +	memcpy(dest->u_name, ptr + 1, usesize);
> +	memset(dest->u_name + usesize, 0, sizeof(dest->u_name) - usesize);
>  
>  	return 0;
>  }
  Otherwise it looks fine. Thanks for the cleanups.

										Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
