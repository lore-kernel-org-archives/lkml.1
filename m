Return-Path: <linux-kernel-owner+w=401wt.eu-S1756887AbYEMRlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756887AbYEMRlR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 13:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751285AbYEMRlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 13:41:05 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:65093 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154AbYEMRlD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 13:41:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=TUUxYJMHNIezf0HMGxXVh7D7DGmpL1Tvp3wjGio0j626oCf7K094DAohaVzc3zHdWx0Lr+Jh6WcppxTDKbpJX8vY0HsAi0w7QL19w67TmVFpNonMhWoPFogo+fEKdf3GL20AtgLK7qDSm6OWS1WJttTvLJ/lBlYVeGWouDQlYX0=
Message-ID: <8bd0f97a0805131041le91646dqa3abf2f15a012e@mail.gmail.com>
Date: Tue, 13 May 2008 13:41:01 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "=?ISO-8859-1?Q?J=F6rn_Engel?=" <joern@logfs.org>
Subject: Re: [PATCH 1/1] [MTD/MAPS] Blackfin Async Flash Maps: Handle the case where flash memory and ethernet mac/phy are mapped onto the same async bank
Cc: "Bryan Wu" <cooloney@kernel.org>, dwmw2@infradead.org,
       will.newton@gmail.com, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080513080727.GA15795@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <1210653525-19437-1-git-send-email-cooloney@kernel.org>
	 <20080513080727.GA15795@logfs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2008 at 4:07 AM, Jörn Engel <joern@logfs.org> wrote:
> On Tue, 13 May 2008 12:38:45 +0800, Bryan Wu wrote:
>  > +static void bfin_copy_from(struct map_info *map, void *to, unsigned long from, ssize_t len)
>  > +{
>  > +     size_t i;
>  > +     map_word test;
>  > +
>  > +     if ((unsigned long)to & 0x1) {
>  > +             for (i = 0; i < len; i += 2) {
>  > +                     u16 *dst = (u16 *)(to + i);
>  > +                     test = bfin_read(map, from + i);
>  > +                     put_unaligned(test.x[0], dst);
>  > +             }
>  > +     } else {
>  > +             for (i = 0; i < len; i += 2) {
>  > +                     u16 *dst = (u16 *)(to + i);
>  > +                     test = bfin_read(map, from + i);
>  > +                     *dst = test.x[0];
>  > +             }
>  > +     }
>  > +
>  > +     if (len & 0x1) {
>  > +             u8 *last_to_byte = (u8 *)(to + i);
>  > +             test = bfin_read(map, from + i);
>  > +             *last_to_byte = (u8)test.x[0];
>  > +     }
>  > +}
>
>  The pointer casts are superfluous.  Linus prefers variable declarations
>  up front (sorry for my bad example).  The "+ i" in the last conditional
>  is a bit dangerous as any changes to the loop can break it.  Linux code
>  has lots of churn and not everyone is careful enough to spot such
>  subtleties.
>  And I believe you can improve performance by killing the put_unaligned
>  in the loop.  So if we put it all together the end result should be
>  something like this:
>
>
>  static void bfin_copy_from(struct map_info *map, void *to, unsigned long from, ssize_t len)
>  {
>         size_t i;
>         map_word test;
>         u8 *byte;
>         u16 *dst;
>
>
>         if ((unsigned long)to & 0x1) {
>                 byte = to;
>                 test = bfin_read(map, from);
>                 *byte = test.x[0] >> 8;
>                 to++;
>                 from++;
>                 len--;
>
>         }
>
>         for (i = 0; i < len; i += 2) {
>                 dst = to + i;
>
>                 test = bfin_read(map, from + i);
>                 *dst = test.x[0];
>         }
>
>         if ((len & 0x1) {
>                 byte = to + len - 1;
>                 test = bfin_read(map, from + len - 1);
>                 *byte = test.x[0] & 0xff;
>         }
>  }
>
>  What do you think?

actually, i think it'll be simpler to just scrap the whole function:
static void bfin_copy_from(struct map_info *map, void *to, unsigned
long from, ssize_t len)
{
    struct async_state *state = (struct async_state *)map->map_priv_1;

    switch_to_flash(state);

    memcpy(to, map->virt + from, len);

    switch_back(state);
}
-mike
