Return-Path: <linux-kernel-owner+w=401wt.eu-S1756918AbYEOBR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756918AbYEOBR6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 21:17:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753413AbYEOBRp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 21:17:45 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:26892 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785AbYEOBRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 21:17:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qgiRaAhrn0AaxvWWKsWGXnS1RcNH3YjMcXIJMAwEfZzUDtWguTe5iOa2tapUHyboiNGEnS2Xm16zOWU/h7zE8jPTXkezZIxD70RWIwnwK4IfPzAW3+FiabyszisPyUw9pJpiANsrfk7r3p8/luG0bgNN9Hy9NkZaUB1ECknMQaM=
Message-ID: <d9def9db0805141817n4182deedp780791b0a51fb7be@mail.gmail.com>
Date: Thu, 15 May 2008 03:17:42 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: [v4l-dvb-maintainer] [PATCH] USB: add Sensoray 2255 v4l driver
Cc: mchehab@infradead.org, v4l-dvb-maintainer@linuxtv.org,
       video4linux-list@redhat.com, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080514205927.GA13134@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080514205927.GA13134@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dean, Greg,

On 5/14/08, Greg KH <greg@kroah.com> wrote:
> From: Dean Anderson <dean@sensoray.com>
>
> +static int norm_maxw(struct video_device *vdev)
> +{
> +	return (vdev->current_norm != V4L2_STD_PAL_B) ?
> +	    LINE_SZ_4CIFS_NTSC : LINE_SZ_4CIFS_PAL;
> +}
> +
> +static int norm_maxh(struct video_device *vdev)
> +{
> +	return (vdev->current_norm != V4L2_STD_PAL_B) ?
> +	    (NUM_LINES_1CIFS_NTSC * 2) : (NUM_LINES_1CIFS_PAL * 2);
> +}
> +
> +static int norm_minw(struct video_device *vdev)
> +{
> +	return (vdev->current_norm != V4L2_STD_PAL_B) ?
> +	    LINE_SZ_1CIFS_NTSC : LINE_SZ_1CIFS_PAL;
> +}
> +
> +static int norm_minh(struct video_device *vdev)
> +{
> +	return (vdev->current_norm != V4L2_STD_PAL_B) ?
> +	    (NUM_LINES_1CIFS_NTSC) : (NUM_LINES_1CIFS_PAL);
> +}
> +
> +/*
> + * convert from YUV(YCrCb) to RGB
> + * 65536 R = 76533(Y-16) + 104936 * (Cr-128)
> + * 65536 G = 76533(Y-16) - 53451(Cr-128) - 25703(Cb -128)
> + * 65536 B = 76533(Y-16) + 132677(Cb-128)
> + */
> +static void YCrCb2RGB(int Y, int Cr, int Cb, unsigned char *pR,
> +		      unsigned char *pG, unsigned char *pB)
> +{
> +	int R, G, B;
> +
> +	Y = Y - 16;
> +	Cr = Cr - 128;
> +	Cb = Cb - 128;
> +
> +	R = (76533 * Y + 104936 * Cr) >> 16;
> +	G = ((76533 * Y) - (53451 * Cr) - (25703 * Cb)) >> 16;
> +	B = ((76533 * Y) + (132677 * Cb)) >> 16;
> +	/* even with proper conversion, some values still need clipping. */
> +	if (R > 255)
> +		R = 255;
> +	if (G > 255)
> +		G = 255;
> +	if (B > 255)
> +		B = 255;
> +	if (R < 0)
> +		R = 0;
> +	if (G < 0)
> +		G = 0;
> +	if (B < 0)
> +		B = 0;
> +	*pR = R;
> +	*pG = G;
> +	*pB = B;
> +	return;
> +}
> +
> +/* converts 2255 planar format to yuyv */
> +static void planar422p_to_yuy2(const unsigned char *in, unsigned char *out,
> +			       int width, int height)
> +{
> +	unsigned char *pY;
> +	unsigned char *pCb;
> +	unsigned char *pCr;
> +	unsigned long size = height * width;
> +	unsigned int i;
> +	pY = (unsigned char *)in;
> +	pCr = (unsigned char *)in + height * width;
> +	pCb = (unsigned char *)in + height * width + (height * width / 2);
> +	for (i = 0; i < size * 2; i += 4) {
> +		out[i] = *pY++;
> +		out[i + 1] = *pCr++;
> +		out[i + 2] = *pY++;
> +		out[i + 3] = *pCb++;
> +	}
> +	return;
> +}
> +
> +/*
> + * basic 422 planar to RGB24 or BGR24 software conversion.
> + * This is best done with MMX. Update to kernel function
> + * when image conversion functions added to kernel.
> + */
> +static void planar422p_to_rgb24(const unsigned char *in,
> +				unsigned char *out, int width,
> +				int height, int rev_order)
> +{
> +	unsigned char *pY;
> +	unsigned char *pYEND;
> +	unsigned char *pCb;
> +	unsigned char *pCr;
> +	unsigned char Cr, Cb, Y, r, g, b;
> +	unsigned long k = 0;
> +	pY = (unsigned char *)in;
> +	pCb = (unsigned char *)in + (height * width);
> +	pCr = (unsigned char *)in + (height * width) + (height * width / 2);
> +	pYEND = pCb;
> +	while (pY < pYEND) {
> +		Y = *pY++;
> +		Cr = *pCr;
> +		Cb = *pCb;
> +		YCrCb2RGB(Y, Cr, Cb, &r, &g, &b);
> +		out[k++] = !rev_order ? b : r;
> +		out[k++] = g;
> +		out[k++] = !rev_order ? r : b;
> +		if (pY >= pYEND)
> +			break;
> +		Y = *pY++;
> +		Cr = *pCr++;
> +		Cb = *pCb++;
> +		YCrCb2RGB(Y, Cr, Cb, &r, &g, &b);
> +		out[k++] = !rev_order ? b : r;
> +		out[k++] = g;
> +		out[k++] = !rev_order ? r : b;
> +	}
> +	return;
> +}
> +
> +static void planar422p_to_rgb32(const unsigned char *in, unsigned char
> *out,
> +				int width, int height, int rev_order)
> +{
> +	unsigned char *pY;
> +	unsigned char *pYEND;
> +	unsigned char *pCb;
> +	unsigned char *pCr;
> +	unsigned char Cr, Cb, Y, r, g, b;
> +	unsigned long k = 0;
> +	pY = (unsigned char *)in;
> +	pCb = (unsigned char *)in + (height * width);
> +	pCr = (unsigned char *)in + (height * width) + (height * width / 2);
> +	pYEND = pCb;
> +	while (pY < pYEND) {
> +		Y = *pY++;
> +		Cr = *pCr;
> +		Cb = *pCb;
> +		YCrCb2RGB(Y, Cr, Cb, &r, &g, &b);
> +		out[k++] = rev_order ? b : r;
> +		out[k++] = g;
> +		out[k++] = rev_order ? r : b;
> +		out[k++] = 0;
> +		if (pY >= pYEND)
> +			break;
> +		Y = *pY++;
> +		Cr = *pCr++;
> +		Cb = *pCb++;
> +		YCrCb2RGB(Y, Cr, Cb, &r, &g, &b);
> +		out[k++] = rev_order ? b : r;
> +		out[k++] = g;
> +		out[k++] = rev_order ? r : b;
> +		out[k++] = 0;
> +	}
> +
> +	return;
> +}
> +
> +static void planar422p_to_rgb565(unsigned char const *in, unsigned char
> *out,
> +				 int width, int height, int rev_order)
> +{
> +	unsigned char *pY;
> +	unsigned char *pYEND;
> +	unsigned char *pCb;
> +	unsigned char *pCr;
> +	unsigned char Cr, Cb, Y, r, g, b;
> +	unsigned long k = 0;
> +	unsigned short rgbbytes;
> +	pY = (unsigned char *)in;
> +	pCb = (unsigned char *)in + (height * width);
> +	pCr = (unsigned char *)in + (height * width) + (height * width / 2);
> +	pYEND = pCb;
> +	while (pY < pYEND) {
> +		Y = *pY++;
> +		Cr = *pCr;
> +		Cb = *pCb;
> +		YCrCb2RGB(Y, Cr, Cb, &r, &g, &b);
> +		r = r >> 3;
> +		g = g >> 2;
> +		b = b >> 3;
> +		if (rev_order)
> +			rgbbytes = b + (g << 5) + (r << (5 + 6));
> +		else
> +			rgbbytes = r + (g << 5) + (b << (5 + 6));
> +		out[k++] = rgbbytes & 0xff;
> +		out[k++] = (rgbbytes >> 8) & 0xff;
> +		Y = *pY++;
> +		Cr = *pCr++;
> +		Cb = *pCb++;
> +		YCrCb2RGB(Y, Cr, Cb, &r, &g, &b);
> +		r = r >> 3;
> +		g = g >> 2;
> +		b = b >> 3;
> +		if (rev_order)
> +			rgbbytes = b + (g << 5) + (r << (5 + 6));
> +		else
> +			rgbbytes = r + (g << 5) + (b << (5 + 6));
> +		out[k++] = rgbbytes & 0xff;
> +		out[k++] = (rgbbytes >> 8) & 0xff;
> +	}
> +	return;
> +}
> +


Why do you do those conversions in kernelspace?
ffmpeg/libswscale has optimized code for colourspace conversions.
I know a few drivers do that in kernelspace but it's way more flexible
in userspace and depending on the optimization requires less CPU
power.

Markus
