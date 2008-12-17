Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1758594AbYLQDZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758594AbYLQDZb (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 22:25:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753069AbYLQDZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 22:25:21 -0500
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:49843 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751190AbYLQDZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 22:25:20 -0500
Date: Tue, 16 Dec 2008 22:25:17 -0500
From: Theodore Tso <tytso@mit.edu>
To: linux-kernel@vger.kernel.org
Subject: Re: Very slow header cache in mutt if the maildir is on ext3
Message-ID: <20081217032517.GE10590@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	linux-kernel@vger.kernel.org
References: <20081217001625.GA3250@x61> <20081217005210.GA889@dose.home.local>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="l76fUT7nc3MelDdI"
Content-Disposition: inline
In-Reply-To: <20081217005210.GA889@dose.home.local>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--l76fUT7nc3MelDdI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 17, 2008 at 01:52:10AM +0100, Tino Keitel wrote:
> OK, after glancing at the strace output again, I see that the seek
> offsets are much more linear in the XFS case, whereas they are pretty
> random in the ext3 case.  I guess that this is connected to the order
> of the files in the maildir, which depends on the FS type.  So this is
> a bug in mutt which makes reading the header cache dead slow if the
> files are in an inconvenient order.

I *thought* mutt had a patch which sorted the files returned by
readdir() by inode number, and then opened the files sorted by inode
number order; maybe it was a distro-specific patch that was never
pushed back to mainline, though.  In any case, sorting list of
directory entries as returned by readdir() by inode number does solves
the problem for ext3 with htree, and in general is a good optimization
for most filesystems.  (See attached for a ld-preload hack that
demonstrates the optimization.)

There is also a fix in ext4 which partially addresses this problem,
which could be back-ported to ext3:

commit 240799cdf22bd789ea6852653c3b879d35ad0a6c
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Thu Oct 9 23:53:47 2008 -0400

    ext4: Use readahead when reading an inode from the inode table
    
    With modern hard drives, reading 64k takes roughly the same time as
    reading a 4k block.  So request readahead for adjacent inode table
    blocks to reduce the time it takes when iterating over directories
    (especially when doing this in htree sort order) in a cold cache case.
    With this patch, the time it takes to run "git status" on a kernel
    tree after flushing the caches via "echo 3 > /proc/sys/vm/drop_caches"
    is reduced by 21%.
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

						- Ted


--l76fUT7nc3MelDdI
Content-Type: application/octet-stream
Content-Disposition: attachment; filename="spd_readdir.tar.gz"
Content-Transfer-Encoding: base64

H4sIAO9wSEkCA+1ae3PbNhL3v+SnQJ0Xaetpy3LHjjN1bDXJjJx4/Mi018uxFEnZvFAEjyCT
6FJ/99vFgyQoynaubdKbEyaRSewCWOzjhwUIlvhOGri+H6bdtT+p9KDs7uzA3+3hcHdY+VuU
tX6/v7XV2+1tb/XWev2tnd5wjeysfYWSs8xNCVnL5hmjt/DdRf8fLaxi/8pzx/uD7T8cDJbY
f2uwtT0A+/d2dnfAB4a7YP+d/rC/Rnor+//ppbthkg0irU5czwuiIHUzmkI1UqwjmxzRZJ6G
V9cZ2QLTtfB3wH+/J5M5ubgOqE/TgFywJ7QjmyGx3Ru2geWE+uE0DHzkPaOMked0HrkxeYov
4vkHsEE8panvRvksDjs0vXqGvUA59H1oyvIkoWlGgEfJ6oC0sa/ehgN499woYh1CXtMskM1J
dh0ycu0yEtOMTIIgJlnAMuiSxtB+DuT4itDsOkiBFaR68fqyOw7j/BMJt78ftlQ3OBTQM/gJ
YMyrPHILScjH1E0S6OBjGEUkc98HhEWormhOZqAY1QdLXC8Qo1wE/hNGKCg1jN2IsDAGSpiB
kB8JPEe5HzDikoh675VGj+gsCaOA5AwlRjE8OpuBXHuS4crzSJuSahAzStrs2k1huu1pEnoa
EbgjP5KNLxkfH0zEgixTI4yPndOz0fjN4TEJ4g9hSuNZEGfkg5uG7iQKcGSC/4NP3Dol+0E3
Z2kXxHejLpuEcVeXSg766HkA82+/hPogfYQ1F2itKU5z5s7BXKBiP2RZGk5ytFke+9xOoMUg
nYECp/wFbEZO80kUetjHOPSCmAUdPsIo9qv9w/+uaT7wg2kYB+RwPH5z5JxfjE7PX/1tZPR7
vYJ0cviTc/zqjNf3yhbHo+eXL8wu6CsLI/IxIG6eUY/G05B5bhZo+u10cDDV8uXh25HjOOej
o8uzkfNidDF6/dbo6+TTs6OLsVGvPf/5XFCcl0AyH4RToEpJNLlQYOuTbXwOp8TyqeMHk/zK
Jp/Jp31yc2M+CCIWNLYAUgwxWk7TAY06528uz45GZZ1zeT5yxodnL0Y/vhqPhgMURbgqecoy
P6Sd62eVqjwGw/l6HZuzbjZPArZYDQiQ1WozPwon9boUfFOvA12DU+p1QZrGNXn8aOrFooor
sK7bmjxJ6mURZ9fUdnqGtnOOL09OD5+PR2Rb6a5snWTX6ALY1gR5cy8jQkSHkc+mkccsvIrB
mSMKUcZ/fCeM6b5pVGvodLpfYWbXGGAhBB86mBcFcZXqQYwDAVUL1fxtw3didwavN/tVMYQM
YHZjA96AWUrrzCDAPjkZh5x9Ah5+ghX8laMux1HRT54GALLg2wbIY8T5bF88zdxP8FSf8oaf
SHpCmXya+nVGCPTMERJp9cOBogwHai5uBkiGqrA2QPTI8SLKACZS24J5EZyXTQ5Ib1+x8lrJ
SxM0F7BC0LJMKG4DFbW8ydQvGuGgU19n1aehGkkQWCZSfY61ZsPBsoaVaRfrYMnbqksDP+m8
ZRqGIVYgnQr9sDzK7hoB19alY6DwtVHIIkfjSODiTjFWFkTRLQr7QENfsbIgeK+xtmRX8Aur
19LpACcYb8kAeliCKyM7C/8dAFdlMSj4we25M4lONFCujKxQWHJJmJUMwvmYOw2cqyCDBVZz
Sje9sk2IVQRzC+h56Fs2+e6AIC9/sclvvxEkXVVJ/MW2wRoQOHkak9eX4zGXsLLIiG45xlk1
SGuRXvEPVASCL/YlIJEvMxwWfSvClMkmjx8TVYPQygdAWZAVUBUTtJLQIv/N0AJt1YKlZlVb
WU3VygFv8QCwlIZRq2oCiqdG4j3fmJrngVvliZNkqcVtIizkAbBhJyWsgJn9iM1n1tkF5EKv
Rz9dtMi6pK1D54YOKI3sBbVsoACukV8RS3aVljZxS9oCMwTpLezDwUID59b+naYRbm+C9LKR
hIPGBpJWMktAaGSWtJKZo0AjK6dwRh5zXgJc1ehcPz89ds5Gh8eABQ5iAgLCus0jD73TxqXV
0KEDdlIR9ISd3ugoIWJiWfecZ52HscKQzc1l3jlNg8DxXO868HFoS1vuEepEhYATQKUQ/VZf
+GG/kaV0bj22Cvb2M1z8bRuZUdbvKhQ/KSMT6ZghWOFBb5+E5CmpMGJ2QMLNTaEbFNTSuvkl
fNcRmYpQUQMLErQKAaY3hpYLQAbleLNEQihXy4bbItXXiYhdXrOYpTDHhY6tJWSbuPu3tZ3c
2nbC8x4KS1TogFChgxVQxYfEkWFaMgcMeVfYY1En1K/YUFe/9N4hPD7pPBF6XaD33xXwKUcB
jRkGwh7hzt3AzXsDANdpW7KnSld9YSk56OQOoSZLhJo0CjW5RajJMqEmhVAFplsoahs1De5T
hoseGQi0GDCBl9F0vpjhYCNYoEXgVJsaZVA1ZrysBT9x8LEhm90QqS+XRgtBN8tScJDiGdiK
547juBGkJzDP04uXiBHOyeXF6CeAC1j0zl+9HaGXFDIB2wxWWupZiEJ0qgGCrQCujGdhr4Vs
Gn+4gXAzBX22R6/fnIxO9utrMjqDjiZhHGYNUNIij4sp1aIacEL6Q6USoHSxUsV/tQ52Fg2M
fEWoVXLob/dVUFXBGr2MAQsDG+L7s2oWaAsdlbvmBDai2dRaP1buQ3ijR5Hfkkc0wrHUIdHf
43WeIRukMga3xaLMYh+klFx1NfTwj9d4PgLRgpCzsG1Ao9VWJB6IuqqfHRBdz4KzrvzNg9oZ
CYrVoISzgLubKw6OqFSFj3MmfNJGfTg+cQNjBGaRiuY67MuWckdRE2yDLHg2jz3Zr3Bv6JwD
hHFFQaaYzoLZfm2S3JlkpKIbGz460mN9idJ1t7n5jhuNSXzGDkr4lvWwE1H1YiMv68XWXZGK
jbyk4v5d0eRe3pDAqKCvEtpZCo0tX1Hszb7Nk+bS8LUAa7f59HVt4KSBx0vmlVFapOx2v9Ht
pcftgcPn5BErLU0sbSdlF8qp9inX+npc+nli6Xs17s3AvAyb/sVomtX9Rp91a5mrtFTOYIvd
Uc8kRu3kzAT3kwkTPKm5H06zICU4Mp5FwdRtTq7kQE+bMiCT+7LqRNcbEBb0tpgmCS3elj7J
/LABOrjB98wGU76mBEiAYC0ycb33/Dwc3BecZAHBuC3q2Wa5jDThr8CyRXkAyfh6Kzc7i+cx
pjinIhv1U6E/Yvktl3eWFfmtdkCEYVFu+pBnUXNvpOyPmE2sRz7BtjY3qQgidUYAxpe6KSG7
OFNSxlNL8sKWt3GlQtktMcpjSFAg6eZ5Fcs6avk6qC5fm/39Sm7E1WqTWvrDMx/srDROsRdV
J1/fyCjlEdx9zFJK/civG2bqL5ilQbtTrl7kvb9yNetWzgxBa7db90usgmZQIFgeZN2SnqJI
etJri5BsUtyROmfQddZuK40V+tLD3F6SPVZZim2MhvnP5H6AN9Npd0KNvlO0S5TpyYxfO+uU
IPb7lNbk1g0T0+1cPxG+WzGYzuoZGhigwXPuSFagG5GsVOrkYXqnSF1Ymbs0sslMhpWpTCNb
mdgwLbNpZFZ5DqskOsAV8ySkqYHMScr8BKNRrOpL+cXBhbLB40W+MqLKIy3hHg7Ij1+ahKVb
ZuOxtsamTsCbGauc8iD8G3mfI/yvJQVW0ix8B8LtWvNZ0P18laef8tCfHBT7RML3+p/vzrML
1zW4oJVUu+KvJW3RSUvaMs8sOZrcsfDHgqvJB5UTakxiD1JOnhObdsl5zL+uLdHzcjDDFbPY
8X1zQJObzm8OacPBPUGNM94H1jjj/YGNs38ZtPEmXwRuRYs74Q3sUgc4fgS/BOKMxY92DfjW
wPXXATfxnXIFb38peLsPuomvt/Kzzu9Na+/jMMXH5gbgUpwWl0rbh4PZREzJb4L8y9Kyr9B/
mPTVw9ni07fO01KD7le+yvDDwoVDUsFYIAM/Z/kaKi8PdJYpvJ7935hrq/JV7/+euO8DvHz3
Z9z/Xn7/t9fb3d0t7n9v7QBff9Af7q7u/36N8uAcg/+AdD+4eAGc0qjrzdOcdWduGHXTbs6C
tJtSxroJkPLkn2a1QRROzKMfx4cvzg/ab3qkfWXyU4UDeBgfy/rIj0g7kmuD+aBg3zLNK7q1
Z/D7uCmBrvRLop2+aYyPnfGr52eHZz87p4cXLw863eol04YmpNOV/SlnNk1RoQbqUEinK63o
nqHdilX8SJBPHkq6ZyyTUInza/LR/7XbJBR6mDclXT/40I3zKCIPLdSibZoN3Hv6LV3TeGgd
HdnFRV544xq08bLvwx/Iw3+Qh5+lsgHUYfl34z1A1RmRilDTadSwFv9qul85/vvbW0Nx/3+w
uz3cwfv/g63+zir+v879fzJN6UzeaxdnZNs2mbkxSdyrAG8wf+lN24bLwOW9Xf3mSkTp+zxp
vPemcpJk4aoov1EqL+kgA2Y18sB3vbNe/wiWgIQUKB7NIz9+knFe8mvnyXpDtkR5E/XBu1d+
gEvEZ0pfnkIm9W+s4jZPluIVFD8pE2qcDXKKWw94gSQL4zxA+SGpQx3YxSehKc1jX30UErfR
Sqbi1JePzimF6Jh73xD5XRhEVZIpLYn5KCmUQvgfPqnyazVN51wt4n7cgoCwJAACZZRMwwVJ
l8mppAT98owT1pWYf06Adl6rNPqHX95VLyjJK0X8Zge/VITs6kOaIf2GNwvfVTYUVm+VOa7K
qqzKqqzKqqzKqqzKqqzKqqzKqqzKqqzKqqzKqqzKqqzK/3n5D6MhuNEAUAAA

--l76fUT7nc3MelDdI--
