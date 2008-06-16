Return-Path: <linux-kernel-owner+w=401wt.eu-S1754091AbYFPKxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091AbYFPKxZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 06:53:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751777AbYFPKxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 06:53:17 -0400
Received: from hpsmtp-eml20.kpnxchange.com ([213.75.38.85]:48156 "EHLO
	hpsmtp-eml20.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751608AbYFPKxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 06:53:16 -0400
From: Frans Pop <elendil@planet.nl>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [Bug 10843] Display artifacts on XOrg logout with PAT kernel and VESA framebuffer
Date: Mon, 16 Jun 2008 12:53:09 +0200
User-Agent: KMail/1.9.9
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>
References: <RzbtSgMztjP.A.R0C.dIDVIB@albercik> <200806160102.11717.elendil@planet.nl> <20080616004153.GA7788@linux-os.sc.intel.com>
In-Reply-To: <20080616004153.GA7788@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_WYkVIAylfKkvQg+"
Message-Id: <200806161253.10656.elendil@planet.nl>
X-OriginalArrivalTime: 16 Jun 2008 10:53:13.0423 (UTC) FILETIME=[2C8CBDF0:01C8CF9F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_WYkVIAylfKkvQg+
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Monday 16 June 2008, Suresh Siddha wrote:
> If the initlevel is '3', then the mtrr option will show up in
> /proc/mtrr otherwise not.

What is this init level and how would I set it? Do I need to?

> In init level '5', X server will add the mtrr 
> (irrespective of boot option, if it's not already there) and will
> remove it when the X process completes its execution.

That was a useful pointer. I do see some differences when I compare
Xorg logs; see below.

> Can you also please try if "mtrr:1" makes any difference. This will
> setup the mapping as UC during boot. Apart from PAT WC mapping(which we
> shouldn't be using in your current setup), UC MTRR should override all
> the other PAT mappings and should be consistent across X and VT console
> mappings. As such, if the problem is because of improper aliasing, then
> with this UC MTRR, my understanding is that we shouldn't see any
> artifacts with the "mtrr:1".
> with this mtrr:1, we should now see a UC mtrr setting in /proc/mtrr.

mtrr:1 still gives the artifacts and no any difference to /proc/mtrr.

Here's /proc/cmdline + /proc/mtrr for three different boots:
root=/dev/mapper/main-root ro vga=791 quiet
reg00: base=0x00000000 (   0MB), size=2048MB: write-back, count=1
reg01: base=0x7f800000 (2040MB), size=   8MB: uncachable, count=1
reg02: base=0x7f700000 (2039MB), size=   1MB: uncachable, count=1
reg03: base=0x80000000 (2048MB), size= 256MB: write-combining, count=1

root=/dev/mapper/main-root ro vga=791 quiet video=vesafb:mtrr:1
reg00: base=0x00000000 (   0MB), size=2048MB: write-back, count=1
reg01: base=0x7f800000 (2040MB), size=   8MB: uncachable, count=1
reg02: base=0x7f700000 (2039MB), size=   1MB: uncachable, count=1
reg03: base=0x80000000 (2048MB), size= 256MB: write-combining, count=1

root=/dev/mapper/main-root ro vga=791 quiet video=vesafb:mtrr:3
reg00: base=0x00000000 (   0MB), size=2048MB: write-back, count=1
reg01: base=0x7f800000 (2040MB), size=   8MB: uncachable, count=1
reg02: base=0x7f700000 (2039MB), size=   1MB: uncachable, count=1
reg03: base=0x80000000 (2048MB), size= 256MB: write-combining, count=1


I do see some differences in Xorg logs, so it does seem that the mtrr
options _are_ being recognized.
Attached my "normal" Xorg log (with 'vga=791') which I used as the base
for the diffs below. Other than shown, the logs are identical.

With mtrr:1 I get (added at the end of the log):
@@ -688,3 +688,11 @@
 (II) evaluating device (Generic Keyboard)
 (II) XINPUT: Adding extended input device "Generic Keyboard" (type: KEYBOARD)
 (II) Configured Mouse: ps2EnableDataReporting: succeeded
+(II) intel(0): xf86UnbindGARTMemory: unbind key 0
+(II) intel(0): xf86UnbindGARTMemory: unbind key 1
+(II) intel(0): xf86UnbindGARTMemory: unbind key 2
+(II) intel(0): xf86UnbindGARTMemory: unbind key 3
+(II) intel(0): xf86UnbindGARTMemory: unbind key 4
+(II) intel(0): [drm] removed 1 reserved context for kernel
+(II) intel(0): [drm] unmapping 8192 bytes of SAREA 0x2efff000 at 0x7f2788ab9000
+(II) intel(0): [drm] Closed DRM master.

And with mtrr:3 (added in the middle):
@@ -577,6 +577,7 @@
 (II) intel(0): [drm] Initialized kernel agp heap manager, 33554432
 (II) intel(0): [dri] visual configs initialized
 (II) intel(0): Page Flipping disabled
+(==) intel(0): Removed MMIO write-combining range (0x80000000,0x400000)
 (==) intel(0): Write-combining range (0x80000000,0x10000000)
 (II) intel(0): vgaHWGetIOBase: hwp->IOBase is 0x03d0, hwp->PIOOffset is 0x0000
 (II) EXA(0): Offscreen pixmap area of 39321600 bytes


I've also checked with 'nopat'. That gives no differences in /proc/mtrr,
and also no differences in the Xorg log when compared with my normal boot
(vga=791).

Cheers,
FJP


--Boundary-00=_WYkVIAylfKkvQg+
Content-Type: application/x-gzip;
  name="Xorg.0.log.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="Xorg.0.log.gz"

H4sICIc9VkgAA1hvcmdfbm9tdHJyLmxvZwDsPWtz4zhyn+1fgXOqEmtXD75JqWpykWWNV9nx2Gt5
Zn23tTVFkZDNM0WqSMpjX6Xy29MNkBIIUqI0481Vcp4ayybQD/QDaAANQsd33avkntyRKU2eaELU
rtFVun3l+IaG1E0pOXczOiAm1C8zupgBiKYo9vEduU7iLPbikHymSRrEEVHVNrmhTwF7UI7PVkHo
k6slTdwsiO7J9CUFAgPyIYhWz+SczgI3IqfPcXLfSTlvbYDc1f++DzLg4Simane01vFolSQ0yraS
mruJuwgAvWt1NauTeBb5F4tML6/J+yQg/7mClulEtQZKf6DbZDSe3qIIDnl2rC+WkbeTi6mqCE95
PVG0gQb/7evLY3J8dEbncUJJQpdxwlqxTOJZSBdpm3gP1HskD1m2HPR6X4PHoPvcBbmOj7KYLNxH
StIVYGYPbkZe4hV5cJ/wiZIQmKYZeeIK7B5fxv4qpORD7PqgjmVCU5D7+NJNHgFiQE47nRbjSv02
Of3hhxaZJ/GCeHE0D+7JPAgpFL971yI+nburMCMpzbCl7eOj0x9/XEMvFm7kkzCIEPxPf2qRKM4C
Dx8mkxYJIhBzAXqOIzdEzF9/bZGvbhIhIXI6HrcITZI4gb8/ThguCRZL0AM0lbXrz39ukVX0GMVf
QSLWnA8xb92AnPSe3KQXxve9O9APOBr8edImt8ECKi/BbZi1LKKCKxgDQ2OG4EQ+pahzQVakRjOv
d6eqPfSiLtadcGDuzB9c0HZGTs5zdfBnAEHV/Ven8+9TL6E02gDw5xNyqrRyIEIYIDQtyOKEnFzQ
iCaBR/KCkzLYOXi/RzdQnwOfxmTkJr7AdBItoVEy6M/0ZRbvAhwxycGPfGC+Smku6XCVxWgtzw3D
F+L6PmrJZzhpHQSN3FlYgfkYk/dxlF272QNJl9QL5gH1u2St9MUSFO53gqhwLbAs+sUtOLEfJNQD
XbyAPVZp0ksf3IT25kAuZbbxXpIgDAPvhPgxTZnD0OcgBRJH4ygDNB9GGnAd7p6IR5bQjtx3Ns2i
GcniwfFRLZNFkHrtLXWqovjLoDdYRSnoAHx0C5xt7gV2+7Kk6m5eOzlgJesFwawH2gTb9J47WeYF
PgJ20Iu7fg+0mvZukxVFdlwVN/czQROC9yf3s9wb+ABShsKGIC/sI70FA0gBHPs6jKgRGY6uJzBA
eeAM6XwVklPWumQV9VxvGfjdNPYeadbiGPnQtHDvA29AlGfb01RP4XX56DU8mxQjWgrm4vFl+HE6
ISMyXqxCNrQAblcvKnk3OU8CQBvAMK4UFXe8C/ishpSq8nA1fs5oxAJOiSJ6DcSiCNrKEJWuWWo/
SIfjGQG8EGPIppILAWPLEgziZu7JpgoRarXZw5IcHtRV0kZePACVRH6cvDspGriKfKaJk+Ojon+B
828CcJtw6oUuyTuoUlABqGAvdFOICFX9tdfwqCw27K9YJ/58S6IVi9/2MW/h9WgywA8C/g6RGIYH
8uSGK+ij4LUQB8gDfW4JoIoywP8DCHfBkjiKY7U121aIB8MWfzQNAwPkE0RO3kKiWG1Fgf/kwU+A
gERNq1DTdlPTd1BTZzI13xGoKaqicmpqQc1oM4L11LwKtVxSRWFtALwyNWBhFNQctUJNk6gZ30VN
l6hZ30XNKFOj3yepKVHTvoOaL1vBc2o9ZE3NE2zqyDb1B6pErb8/tYqH+LJNPfe7qEk29WbfRc2W
qHl7UNO2UKOSFRC9xqZUsqnKqck2ncs2nTXYFDvvVpvOZZv6893UVKTmuPWSzis2VRupWWtJq9Tk
ftrsIWa9TdXK2KsqjmhTXelbnJpeUNOE0dKpUtMlaqLeNv10Tc1m1LRt1AyJGt1NDSS1C72VqcFC
zVxLqiqG13YUzajVmyJQU4BpVW9jWOnE83WU4zUTWKmE5CwJ/HtKvsbJo5tgOOZzY+pzoJ/iNOtk
cQdRZwx0wCvOVsBwkJeRAKJlBgsGaLHSgtUPqKhtwR9no9ubDzhDUnApefr5Yvhl/BGh0/VcihEi
k94VSdwIyR/9pvxOOuqRcsTQ2D/S4TSUOfwD8s8qPoAMd7+d/S7SieKoAyvGOUwKH1AMsqALnJQ3
0Z7n/9a0Of1Lmf4fQxu0u1XJalXJmlNoWW2rkpYNUcteSGES4wuaVndpWhU1rSrrFhd6PvpNLcMb
IrxRA6+V4R0R3qmB18vwngjvVeAFqQ6we19RN7bpK9raNtphhtFqDaNxw2ht7TDDaIeJYIgiGJJ7
7S2CXiuCzkXQ2/phIuiHiWCKIpjfKoJRK4LBRTDaxmEiGIeJYIkiWN8qglkrgslFMNvmYSKYh4lg
iyLYu0SYrmZZ4noZrK92imNVxdHXYcGqhIUGcazDxFFEcZQ9LDKZDqsidGoGXV0tZOio8L85uOE2
JUbfH9CeA6UIuKM4WcYJW/QSR+sb5kXv4q+s7h5KYfl7kbjLh8BLATLKkjgMcaUOcV5rk0u6IP/B
RNOZQD2134ZHJxe7pzltXuvwWnjE4R5RNIUqPZ2LOPT9hKYpU+YMxIWHeJV4lKuULXy/MZrJEWLP
2H017fANZRBfaowcpYSxWxdaAn+LDRmfnrXkxszFxsylxlzWBSxPxKBrVmUMfavA/QLDLWMYJQwG
VFHRJiSa2xWqVEM0t++6k+7WptxdFD1nb2wxKcIYIoJhcwSnXocQXTUx1GqKoPU6FSKMKiKotQjG
tmCubunxohqBrIjCWGzi/wbDEjB0TxAbHvS1njbwdhneEOHtGninBK+I9Ovt0BcRHBFhNhcQCoy8
C2zMXQwTDMup6cZlRNHsuqgx3S4QnSqWNONTNEeYUWoz1khhPqnL4OIEVLMZEwHc2DVfVXMrCvDl
zqOJ8FodvCXBuyK8mytLgLcleOoI8LQirSOBeyJ5ryJtX6buidTnEnVNkamLjfHmEnVNlcBnYmNm
FVm1smVBe8JAhA/lYUvTd4LLsmrGYdTNw6jLdtVEWfWKH2iyXQ0R3qzCy4a1RHi7Ci9b1hHh+xV4
XTYtFeFpSVzshw1RgLjzjE0qFvET2/9/oknoLt+iw1t0eIsOb9HhLTr8E0SHHUuubeGBfA2yB7ak
fVuTHb4mC0OSsgNb/1Qr3D0nEWYJoXkSIUbfvSYRdglhj0mEGH/3nESIEXi/SYQqzrb2mUWUw+4e
0whVKyEoSuM8QhXnW/tPJDYmP3AiIZp+/4mEdVB/lSJxU4etxOLGiUpfBt85UdF2pl2qE49KMG6Y
qEjBuHGiIkXjpomKFI2bJiqaPM1qmKjI0bhhoiIH46aJStmyjVOJ/k5wWVYpFDdR19XDqMt2bZio
6LJdGyYqumzYhomKLlu2aaIim3afiUrpOBp9zhaxv9dpNFqcieMH0zimfC6Nl77msbSccOlkmnxK
r+bwmgyyOcCG5/lK4q4FI9OfhtfjbZWXk9vO9NPH85u/dD5efZzeDj+eD2/Ot0GfTS46N+NfPo2n
t9Ot7P7ycbST2+hmPP7YmQ4/j2+2wd2NOpeT6VYyd+8TSh2r8zlAm9ONxhrgL4PUa4I5vxhuAzm/
vtwq9e3VRWf06XpbNWuiT31ocrpyw85kc3B8a4PYScXdtZ3LGEmMwPmgfDe5zk0+oazpMP6Mfktv
ATS5q0DR/9V+cn716ezDuHP26f170TPXSroPn79FSYAmKwmK/tAzrg3is4Puk4sPd+VDPFWNAEiN
HubQUbKX5X4ekx/ohvICTVZGUb5dI+Rf2QsgQ7bevOvc3uLrNH+jXnaAqrSuus2fSuefa7RZqhdV
aZYVwE7j4yjCT6FX9JZQL06+KSpxTFlxvPSVHEnV/7e72814dCVGms1glATfNBglQWUwSoJ/ZD9r
CDQ3kxrhA0dV9pKen/MH0RHji588ycJj+atIr3X1rlrvG+Jh+sPO2lcEf5zt1zUCfMuh1wPwOqGh
+JUsvlXm/D2LrUKX3sNoknqRv520t9wMoU5yVvFqsm8ZC75X9gDPtgxyfNYOftql9lzLQ7BMaQa0
0ZPbx0f4q+N7sA5usyLKfpn4qSuXbeIY5gV8mtrFZc8xzQsssrCor8Ln8dHY1jSVnAbw2OKFANFn
SPiZP1yO4TdDu9BN9ucvWGFd/BVIYMUlr78c9y4+jBFKb5NfEPQX/Gu7PPzdtPxUURIs3OSleF8t
SPm7JflrHvxQ0DBNg/to8/YZSSHioTbZ/moU45mcyTm+trTMqfk5B8TOtcdEAkWDG3DO9Zu4z3PH
GoVusHgfPFO/mCimpy2CL8K9bT2+bT2+bT2+bT2+bT2+bT2+bT1Wth7rQypePQDB+y12vsXOt9h5
eOxUCpd0RZd0ZbefbsLnGmMmYsxsgY2A4IgIjogwr0coD7NN8Vzb8XJabTyXImhTPNcqR6R2x3P5
iFRTPJfH2aZ4Lo+zTfG8Ms7ujudyCG2I5/JJmoZ4Lh+k2R3PK+doGuJ5QwitRNzdR6QqEXf3EakK
9d1HpCrUZbs2xXPZrk3xXDZsUzyXLdsUzyun33bHcwhuijAwQEATjAsPzDE9QMhHBUMtQ3sitL9p
znR9wGfKbxkiT/cu2/9I+a06Sre8B5SuZsXGzEkQZaU9wc1eoVSx+84NBl3ZJMTCf9R9G9sEfipl
o9biPu2ZpMKSp2pm6unVMlPqqwl67z58rRVVqmgQFqEr4mLhqwisfJvAbK/vVGkNyCih/Cqy4qqt
8yBdhu4L6qLY1Aqi/EKpYpvr+Khy0xS206fL7KE3n82WS6IZPV3j6awNs3MEgKr8dq954i7obDWf
w5QccaoINxdn5CsN7h8y4jhOlRxvwxPL2+Jre3jP0CgO40QWc8cmJq8MT29abEOOb9EJCiqgTrD2
RK7+EETUTUqiuBnZzMVk+MkVrEnugxSWIey1RNfHN/3XMzC53Rrxc3ssgyWuX57cIMS8YFdWBr/h
anw3ZKZwPY+GNKnJOos+7vtenYdjseiurIC4IbiK/0JmqyDMOsEOsoFWSxaLS2SxYAvZjVxXqwy3
rT9fDPP7fxb5FWaFd0o3mVUsr43YG5Ino5vb8/PRl+EJVAZZ4IbB36nf3Qo+Pf98hW+HfhkzheLj
WTNqvh1ciz3AT/GVUKBX+AL4Ze4MFK+BeLaVCvmPMSNTsGD7xnjvE6P9Om1ZxE+Hq+Rb0EbfpclR
pfWjHZrUDtLk6HXa8k0q2YVWNKHw4gH0SW271MOq/4zPJ+d5yCEnH8ejkzbug/gk8IltVgae6wT+
xu4G3Mi9mz1QfmGfT/G+xXQgwxc15MQyYAbvKCfPMOcghJhmFxYoBEqJZWvEthziWAYhAAI/DjH6
BjF1mJs9pC8RrAWe2K9TS+/a5PGnv7e2M4Ih9tlS1owclTGCUvjTIn3FIKqCnAAGfjT4MYmlmzIn
2+qqDZxg1WY8Q8tzVirM1ZAVFucfqqoRVe9rhAnIfmyL2FAgc+sDhQZu0OBnVVtLBjP7ronsUBDV
ApFUx7SIBs9QqGEhrPvwA2o0gPyRs/wxZ9nXu85hqjSUjSrBbn0QR1WAZa5KlasSVsESJ93u9hs4
Sd6hmV2t8A5gYJsa48q9o48/GjG1is10tWs2MLI1tluyZuR0dbQOcLN1cEEDPQQZwYcBxjNUgxhG
v2D04/6MVM3BRaVmFN6hc4/HcvjoW0Q1DDQcOPvaZUzCdhHAQS1ZiY7S7CFlfyS203U2/ojMVB3Y
6uraH/sEr6RD1UrcLOVQ7wdDid5vgBSqA3/phpFzs1X4sYGbJdvNcLrGga7YZ75f9GoH1Sm5ogGu
aMpyGdb+rugYXSBIdGGkgk5mg32QZT5S6fBjE1OxZRcxtEZOa5mAUx/HRKtrm0X/ckhfK/cvHX5s
GKp0mZXZPChujJXz6ht88ODWQvWxEUOH4UmwlgmNqTi/5TSz2zi/2Ud+wELwfh1HDgOZ2uiLhffb
8KGz4bki4h7jvsATZMROZXInyXmCZKqJ47GNHlnhaTsyz/4enXwzJudyWjzc8EEZpVMd4F4elHX8
AMaaYco8beMQnrbJA4HB/CbnCUMZ8HSAJ9qywtOs8ARXqO/rh00NhBm5F0cRTMOLU4o7Zu35dA/X
CJSsLSij+TRj5CAuWOTxjFzc3lbmMWsYuw8jOgClWRzC2pTfKVNZFz2xlTB/Ae6FPNKX4kJZbIE6
pzL8r0EYsrt98UZfAOPHMMnSvYeZYhgslyCNjHObBEt2EQuu/9hiOkjzw5tlQH4C5e7pEid0Xow3
uG4D5eu5e3excEHNSZKvdk7B7dqk+MhvdxaWxPlq0Q8W+fm7AQQxC6A1W2mRxaKCgHfmcoWcwiQG
qJqKcGxfXtrNZ3Uru1Lp7v2Q+axyxnT2h+5xyRf27jgHKApKn906ScvFu0UF2OrLCq9zga7W1V5r
nytxF75bu17Pa0pL9ryscdWOp95d1hVghZLyG7Hzy/HTzE0yslqiy/Fjw9cJncDwwG/iFjZ/8rUN
9FQLJtgGOb2+urn98tPV7fWHTxdfprfD2xbxHjCxm9+5LSR0WAdnf85wVwX7VrH7RJbB88JdEn7K
H7eNYByZLZdcBj8mExJRIHkzHP2ZwGKxDQV+HP1b1t2dU2ZC5DllZb80XpHAKhD2yeBN19lkZb/k
3bSaTD4o011KS+yV6S5lJvbKdFtbU3LbMt1iXlnA2J7pdkoIzZnuUlJ5n0x3Kae8V6q7lFTeM9dd
yivvmewuJZb3SXYbZYTmZHcpl7xXsrt0+8beye6N1Q9Mdpcu49jdXwSs/kHJ7tOrZXLeyjPM+6e8
N2jqIYnvDZomJrq25tGKcaOclGxMlhtbe6ZSnywvpyUbk+WWDL47WW5L4E3Jcjkp2ZQsl5OSDcny
6sUNO5PlunwWb3eyvHJka3eyvHJiqyFZLh8kaEqW776To5LOtnaCV2S1D6O++yRehbps14ZkuSHb
tSFZbsiGbUiWG7JlG5LlRuWQZWOy3Ng7WY4jySeGY+6fMs+RpHnfzzSJYIWzvpfEcPqwJIbZWOaG
sLaAxWB1rThxdGWEXzw0LJJbl2wpNyBq37Qc0CQs8taJr2M/WeDXffDj+QNYqsGCMnIX7J7Pnk+f
8O2bHl6yrcigMX5LCMzeMGcY4BWh+NU/MX5lyEOxv46pM76J3npdbPYNJXMXJ/f/fyQ4ezmD1b0/
IFPqJt4Df9EuwftXJ+f4hSEDdBx23zsuQV5N7D60++rnVqUV+fNlEMV49022SiIArgO7oBl7yB01
rTaW+ehvAPo7CfGrVnzyyF07XzehnCf4uspJ/kZNV0Q5v7lkDp7MXW+zblOLBecGiEm2cNkyh311
DfVrEkAcnu8I4NuWiBnG3iOZDm/GQ1iMpTFPwCfuV+wj6RYKYpYaVkBLkGr2Qnz/OZehHgscAgDx
O0fYCs7HXZ+MPmeMJdeKjHi3hoHlmQ/qeofbLfXkgwhWhCEuelEsfK/GDXO0RN6teC8IgGtldFTU
7GYTpQx/G7CviFq/SlveYmGr5Rt3MSCapamGQX6u5FGHWUYXS5YIy+8shqbGnrt52Sdj63Xepqre
b1mtgLP5fqItNrpZnw54t+NcAIdlC+xcHe9Khw7qoHOLw0o5ykjprEI+ZW6L1ioKd9L6n96urTd1
HAi/n19h8USlVhsSwu1hJS45LdpDYQPd9uxqtQoQaFQgEQkt/fc7M7ZzD6TRavtwdJrOfHZsZzw3
e5YWLMIElJ4HpZeAouSRJFYrD6tVAot8Is6K4Qo8HW1f4LXz8NqX8MZRkFp+/9bWY6+25UFbB2uL
bhZN0/VmE5NXMhDO3zI5hdd78+Nh70zIFV2M34WLsdAv+Hx0AvsOFv/SoQNo5IQIzRd8vZgJlG7i
fWs9PIPwG08HFp5IfP3w7n7lv6Bgha1eW+P44OPZeDrdbNA3yP8SDpLx0uc+XvgrTwsSDhXraFtY
pELrair5qJefARZmizOJ44WxuLV/8lAGkzRB4bZx4Wv5oFvLPJHBIsPN8mfu7px18tHQ9T7TT/ae
68NgsbppPI4MM5EUc5Me1wEsZfKNBVgcsWj0587uDSU2HuhMntCPO3nFFCPcwzMbno5+Ni/lr5E5
DoUflw0o0bCCXJoUTwAOnMP6vm8upGoEs78mb7bCF7dwH4Ca7G1dPm1NpdvKrICLWA2BpWawOo2u
+jUsVWDpGSxQpjvZpXkRTBNgrSxYU29/8S2bAqydBeu02tnXpHOXOeJ/R1UYM5kQkaF8R/8lr0wv
IavrDTCK3waZlohejVjVLrHCGlrRGvJZvYna8G2skfamw51T3uunj7URvxXAWiGs1iDYnbtFeqaN
wt26ThGVfABNjQBUApBBlSihrd7M9o74rvSuvUS/Yo/Ffmxe8CYR3MlhbURDzX1m0K/EDodjreCg
3YBWQpt1DooaocB64ij2GYWZFHF1rdPkMDnsesSuy07Et8ZSfWhFIC0JktgUS6G0I5SORMlshzDN
GPrNfRm5d+RNhgUCGREKon0rUdmTF0ZMEzE2czyb9XE7cTMBAxaGruCfgyA7uB9SyDIs9RqGG+lk
NaFltCjRzICa2WyutTOQ7UiJX9DQIKehWJATC19kO5evVKwpokf5YnF14FZESsfm76zRSrOa0C0T
LAhVDsgtA03ZPdqpPZPThS+zxyIRWzvTebwuqWj/mts8PMNXy5pHUAuIpAjIpeEFVUE84PUseN6O
GbJFTIpNdpUzJ/ZOGVxKX1L1MClHzG88SN1AdZVpYcwXJUl/M34OpuGVXFfJh3f92ezenMqrqK4y
9MlWELmFX3yPuTF8MseLn2WH6tEw+5N+Serv4xdjXpaWX6kycLZ4CU85Jq6wlaTtP45Kkg6nk9l0
Pl4Y5chHMCD3JWlfjD/Gxn/n4mgoBT6O/9fTUtiNXFdLQ6noa8G4L1161UNlRFTJXeGdFz4KU8zG
kFaCMKeUs6pV5GtW5NMr8rUq8rUr8nUq8nUr8lkV+ZYV+VYV+dYV+eyKfJtqfFrF70FrVOQTfgvB
94M7O1EJiukmUZYLSg50e/4Tv9KLOOO+ErBt4SEmkaFicEycpsvRJMi/Jn0JwlBgPiBhr7WWws6Y
vsSde1OPjK/aEHSfVK35dAn6HlhrH9anH0qeFepL9rt9CPwk2OzoBu7K3dVYDezxw/oSpqTtMUma
xMIy9abt2VYAaGAZME2pJSle3pYmFS9nNUwaKmxJ0vUSdDEUyhWsYYnvhtK8BEOEvSRhDOcHWbIA
dPIvoXCyXowsnIwT2Gl7IMacNnwv0LwLkZLEKd9tzowYZ28HE3eczX9RBehQWBp0JIHu1pIbWI32
N34h1x6eFDJE01iugbJLiXekltcRdCVlgXlmmq0NTkHgHvzb8MHC2ds03rpS1Kk/+2fHn1jkMQST
kyOggwM+X72ISTTUY90iijkqNYHz7gQYhOMfrI0l1eVRQYoV1dOMwpoEXXL2tOhhjbrwdj2UKQ6/
f0weZEkx11id3zQ5mT7NjZvCRtPr6UuNppnDRqUmL9CyQ+L5KjdeRlZgmbQIaMzDoM23fwGQ1xEX
gYYAAA==

--Boundary-00=_WYkVIAylfKkvQg+--
