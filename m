Return-Path: <linux-kernel-owner+w=401wt.eu-S1751385AbXBDAYK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751385AbXBDAYK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 19:24:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751258AbXBDAYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 19:24:10 -0500
Received: from pool-71-111-65-226.ptldor.dsl-w.verizon.net ([71.111.65.226]:26237
	"EHLO IBM-8EC8B5596CA.beaverton.ibm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751395AbXBDAYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 19:24:08 -0500
Date: Sat, 3 Feb 2007 16:23:38 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 3/7] barrier: a scalable synchonisation barrier
Message-ID: <20070204002338.GB5647@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070128120509.719287000@programming.kicks-ass.net> <20070128143941.GA16552@infradead.org> <20070128152435.GC9196@elte.hu> <20070131191215.GK2574@linux.vnet.ibm.com> <20070131211340.GA171@tv-sign.ru> <1170280101.10924.36.camel@lappy> <20070131233229.GP2574@linux.vnet.ibm.com> <1170288190.10924.108.camel@lappy> <20070201004849.GS2574@linux.vnet.ibm.com> <20070203163850.GA675@tv-sign.ru>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="k1lZvvs/B4yU6o8G"
Content-Disposition: inline
In-Reply-To: <20070203163850.GA675@tv-sign.ru>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Feb 03, 2007 at 07:38:50PM +0300, Oleg Nesterov wrote:
> On 01/31, Paul E. McKenney wrote:
> >
> > QRCU as currently written (http://lkml.org/lkml/2006/11/29/330) doesn't
> > do what you want, as it acquires the lock unconditionally.  I am proposing
> > that synchronize_qrcu() change to something like the following:
> > 
> > 	void synchronize_qrcu(struct qrcu_struct *qp)
> > 	{
> > 		int idx;
> > 	
> > 		smp_mb();
> > 	
> > 		if (atomic_read(qp->ctr[0]) + atomic_read(qp->ctr[1]) <= 1) {
> > 			smp_rmb();
> > 			if (atomic_read(qp->ctr[0]) +
> > 			    atomic_read(qp->ctr[1]) <= 1)
> > 				goto out;
> > 		}
> > 	
> > 		mutex_lock(&qp->mutex);
> > 		idx = qp->completed & 0x1;
> > 		atomic_inc(qp->ctr + (idx ^ 0x1));
> > 		/* Reduce the likelihood that qrcu_read_lock() will loop */
> > 		smp_mb__after_atomic_inc();
> 
> I almost forgot. Currently this smp_mb__after_atomic_inc() is not strictly
> needed, and the comment is correct. However, it becomes mandatory with your
> optimization. Without this barrier, it is possible that both checks above
> mutex_lock() will see the result of atomic_dec(), but not the atomic_inc().
> 
> So, may I ask you to also update this comment?
> 
> 	/*
> 	 * Reduce the likelihood that qrcu_read_lock() will loop
> 	 *	AND
> 	 * make sure the second re-check above will see the result
> 	 * of atomic_inc() if it sees the result of atomic_dec()
> 	 */
> 
> Something like this, I hope you will make it better.

Good catch!!!  I will make sure that this is reflected.

Also, validation is proceeding nicely, if extremely hoggishly.
The validation program and output thus far attached in case someone
is interested.  The three-readers/three-updaters case has worked its
way up to 16% of the memory on a 48GB machine.  ;-)

If it overflows, I will see if I can get someone to convert it to
VHDL and run hardware validation tools on it.  This turned out to
be necessary for the -rt implementation of RCU...

> And another note: this all assumes that STORE-MB-LOAD works "correctly", yes?
> We have other code which relies on that, should not be a problem.

We have been working with Doug Lea of SUNY Oswego, Sebatian Burckhardt of
University of Pennsylvania, and Vijay Saraswat of IBM Research towards
a "universal memory model" that accommodates all machines.  Currently,
it does in fact handle store-mb-load the way we all want, thankfully!
Actually, the other guys are doing most of the formalism, my main role
has been programming a very stupid checker based on their formalisms
and yelling at them when something bad happens.

See the cccc directory in the x10 project on SourceForge if you want more
info, but be warned that the checker's UI really sucks.  It's input and
output formats are abominations that could only have been dreamed up by
someone who started out on punchcards and early-70s BASIC.  Not pretty,
but it does a good job of letting people know what I think the formalism
is saying!

There are some people working on a Prolog program called jmmsolve that
as a much nicer input format, but I need to prototype memory barriers
before they will incorporate them (currently, each statement acts as
if it had smp_mb() before and after it).  Also, their output is as yet
incomprehensible to me.

						Thanx, Paul

> (Alan Stern cc'ed).
> 
> Oleg.
> 

--k1lZvvs/B4yU6o8G
Content-Type: application/x-compressed-tar
Content-Description: qrcuval.2007.02.03a.tgz
Content-Disposition: attachment; filename="qrcuval.2007.02.03a.tgz"
Content-Transfer-Encoding: base64

H4sIAH8mxUUAA+xd+3MbN5L2r5q/AnHqUlRkjfF+yJFrkzipurrLZdfOpuou50rR1MiiLZFa
Ppy4tvK/X+NBcgACQ44ly5daTSUaaYj+AHR/aDR6APpvz7/9++MHH/fCcCmB7Z2EOyacu3u4
HhAsJKGUEUYeYEKIwg+Q+MjtctdyvhjOEHpwPVxeXo3edpRrZvO7aNDdXn+z9r+cjt7WFx+t
Dmtgycv2Zyv7YyAAhudABEkfIPzRWtS6/sXt//lZcz6eNGh+PZ78ankwuFoumt8P0f9WB2dT
+/PkBBF0/BQNF9Or8Qj90z47OBif+zt86gTQ6SnCtph7ehCeIfIkPHg1a4Zv1yLN5byxhedv
x9f+4fnY3f+wP6dnVRW1azlJWraCx9Wn1t+f/dqMf6vpejEbji9vu44d4x9cvliNf8mwgPHP
Cbsf/3dyHfMT919FTvAJZRW1N14xexMVP4HHlYCfpJK+gII/aKXtI1oZe2MVwfYOGMTeRUWo
vcuKMCdPuAMgwokS6WWJCsI6CBsvTLEXpsQJU4dVUeaEKffCVHhhKr0wVUFYB2EHpipmwSit
GAn9or5jzLeM+ZYx4fvGpKuEKV8J074SZnwlHPtKOPGVcOpAOHMgnDthLrwwl16YqyCsg7Dx
wgJ73TqsSlAnLJgXFtwLC+GFhfTCQgVh7bsnjO+exL57kvjuSd8y6VsmuX2qKukNIIMBZDCA
DAaQwQAqGEB5AyhvAOUNoIIBVDCACgZQwQAqGEAZJ6wdVqWJZw31wpp5Yc29sBZeWEsvrJXv
nta+e9rYDujKuG6aythuMlwZGu7M3z/1YPoTXs7//2M2Wjr//3Hq2OH/GVzB/3NGufX/EAXK
e/9/F9fn48nocnnWoId+EfBwE3r916+WHL8+/+7rZ989f4FY+sHf//rs65/sJ7SqXo0XaHzm
QrIn1av3iwaNFrNf6MvwBwR/Z83sejZ9PWvm819iZFsIxNcx3ZOqgpKjxfvrBllm/uqlBw7p
qjms/lkdjCcg8B5qhMIQp66jVAgh3WPAcR8eHKzCVh+0hvjTNs6Ve4meurDVxaibp0dHTzZR
ayZm9RGrjVdttAplkw5eNS9d8Fv4gMIH63B6U+vxMfqj+qMV+y6vIPSdzgCgObNhbxSC++h8
HZ67KBokAN4i4pch8h63ovBNEF6QIm0pvCUFXbV3F6R7IfvzyImOX6ZmW16fDRcZu42h9y1W
2PG32KaEKwrwqYGhGY+/RC8mw+v5xXQRMBCALJoaffm4Sk3uGXVw4EBcx8foq5TbgQDtBo2t
oRLrjV96WoyPjtZYT08LYGvuwHLGEqVyit4Y1EI5QgKMVeNXp94kUaEqR73zcSr7dEX+g3Qd
5xocce0zT3Cgmu2JGyqfhbGSKeg42dbe+pMwctbjIfpstRpsKeHJunnRcu5JsYve0j83s/H5
+5WdV6boNrXn5t5mb1N5kHLAWuWLL1y5A2SvLU64Moc9mDGcw1yyGLhqoZmHT7J8sXdgzXgC
vnEzcqp2l924c+p2vuagpX/f+7VKnBa6lJDpVVDgbDmJ3PDYt9f3tNjRteW94bsasp5HQktW
9a38R1eFLdlWjeCiQHWfemr9U1yt9f9HSwDuyv8RzDb5P8ps/o9zdR//3cVlHTI6HqJ1Cqj6
HI1G6PjZi6+//+6n/0bHU3Q9nNj/61FlP2j/XT+G+/04+zNfcf7v49SxK/+HCQnjn4X3Pwxj
fj/+7+LqXP/954/f/odf+qUrNPvnxfBdY4V+WReE8HgTta8XA7ZMsgyIV2y5mHUNvllKpc9c
PLEdUGYDp1Dc/v4G2tZMzk7sAqrahCKrvroWrWvaxEE2LAk98QGJi0c24Ugk3wpA36x+aYeq
66D0zXbdcTy6bsmbsPaweG/gA7JG2K4+E0y2g86vVvFqKOX09amJeH99kiv3/qde/L64zTq6
/T+RirLN+x9B7fsfJdm9/7+L64Vd6I4nr9GJ9Zcn6Lfx4gJdj88QrhAiJwfWiyNYyw/854fo
0k4NiJowYVjWPEQDl38Br3Lwy2Aw/oodHr4EcVoUZzgnTkE88bwvq3UDvfPdNJBADaxcA8nV
wGwDI0/uGtoBQ3MwHGDslDIYHxEHwFcABA089AqA8LKirsEnr3QlygiipKuBr1zezEqqZ81O
h36uPT3FH4ZhFbjeImABdE8AYlvhpi8rbcrSMivN20wLEQYAEVwGUlkgsQ2ELRApA+kskGxp
xCHQMkLeqgoQLKMsL+3dU5Owm1KTdJB7BzVJX1ZnuNUbI+UWkTfhFumgdj9udVC8H7c62L4f
t2gHzftwi3awfD9u0Q6W7+AW7SD2vtzqjZFyi/YdGxG3aAe1e3GLdlC8F7doB9v35FYHzXtx
q8xymg0eiF6T6+mpZxfDJ8hhELRoZlfjCZSbw+NyWHNLcQnriHx6xCVdMHvFJezGzp99uPNn
4kZxCevrtjPjuzdGOr5Z38AmGt+sYyz0Gt+sw+X3Gt+8w/PvN755h8/vM755h+ffj5q8r/Pe
UJP3ZXWGW70xUm7xvoFNxC3eQe1e3OIdFO/HrQ6278mtDpr34ZboYPl+3BIdLN/BLdE3pMlw
qzdGyi3Rd2xE3BId1O7FLdFB8V7cEh1s349booPmvbhVZvnecYkw2bhE4o8dl8iOyKdHXNIF
s1dcIm/s/OWHO3/Jy61nOVHh45LTYD15C4va3hjpAJc3WtTK21rUytta1MobL2rVLS1q1Y0X
terDF7XqFha1vTFSbqkbLWrVbS1q1W0tatWNF7Xqlha1qoPl+3FLd7B8B7d035gmw63eGCm3
dN+xEXFLd1C7F7d0B8V7cUt3sH0/bukOmvfhli6zfO/AROtsYKJNecbM0tb2MbwCB1TTEddk
bW47+GYl3BFrZBXse/UmjJcu8ax2zbrp9lX5Uev1+w44nlcyDn0ZvPFmMh05nX360yH+If0p
w+3bn453Z/v0p0P8Q/pThtuvP/bDE+TegqNmcjZHw3MYCYCL5ovmel59btGb+byZn7gdGJuD
qK1NI/hl+oRsPaGrJ2GcdKsi75PYYcXRukFoBF5y0Zz128kRn//5JOc/sZCr859M2o2f9vyn
uj//eSdXdP7TGHf+k2DsDoASTCru7rQS7s7cKVCCuTsGiisdPjX+gCcOJztJONlJw8lOFo6F
cn+sj6zAyAqNeDji8aQ9Cwq/2HOe2P3C7GnQ8ISunrDVE7564nDtKVB5AlVpeyoU7saeCvV3
A3d7GhTbu7SnQrk9V8iovRt7KpTbc4SM27ux50LhN2zPhcKd2IOhcHcHQ+HuDobyE0HtwVB+
opk9GAp3bg+Gwl3Zk6Fw1/ZoqL9bPEP+P+21ao3/T7b/WzGxOf/H3P5vge/3f9/Jtdr/vZ4C
du3/fvbzd9/+9OPzF/9zyrGRuf3ggEBXZ7sewa/hHMf8BD74d5jWxsNLdNVcTWfv0Wg6gfnv
ejGewqxrWK2ERj98A+V+GL5Nz78tfpuuvoNieg3Tr9S1VLhVfHh5iabnyO379AWhkKwV5bYQ
lCKhVVGjEK+5FKEEy7YbuZwaNGH+2/D62ubWxos5egVT5WSOpktbG6KcAkYNGDAhv2lGi1D1
l/722NdyioxRNcHGF32+nKDpBL0av34NQcbVcHQB0z0EFo+M4jVj/IdvBp8dQrlvlvag23x5
uUCvpq+Xc3S2bNBiajeHutZMziAIOW8Wowv4PfS9rut9/Exu/r/j/X+UYrmZ/4U9/yswvp//
7+T6sP1/MOejh2vWROmK9pm0zk2AYO0cBg0Y6LMBwByuFtrlPXowa+RwWMg542h/3rawzAnz
8CqaJpvztsVVTtwmC7IH6lrp+daRunhPY3E7H8E6V5lc5ejjQ3rdWwPBBeWwVLqxsZ1UaOG3
sy55GoS9ifpmijc7qs92wqW8BisePsV7QdkcSZ5ELUKvQYN2dmGSUhdbZ9TTbYe5boqslqNt
amRHU7I8demx/NH1dAtiDjNLR5Ihfzj1nm5HzGFmLeqSZq0z+8ES4dQ8CbsUc6krcpdDl9zi
0O3C2mvokhsOXVIeuiQ7VnxiZ/z01I/dLvn85NH22KSYciQk6+7JynO4vFJsqhDIbWxF23sg
tyvIDzcRGWtzOPnwZTdaXs8yMRctz7W30GHW3mp5Kx3uQNuzw+UJ/RY6zNt7M2+lwx1oe3a4
7IpI3jur1YgKm2XXLoGHER2auBrSIq+31rDa7O8sQWT7QqNZeTdItjts7VnnHV+wsRd+1pmm
mww2O1Fv0tedIDfs6078/fpqdsFk5wwRu2yGd6Fkx41pb3kkOyBknqObeWez6bUfAl2/GPBf
fxNtf+0HtZqISLQBthcG3TTHvafw35ATb4stAeZp6d/GAtZXpyTZ3NoPiG9UvWugFRBERtW7
eFyAkm1V7yJxHoOJkqr5Lj7rbCAjbaPs99FE2137QajNXtNdfNbZXincctt8F5F11ksoEvmy
3Sj5wDKh8iD5ipxT4OMXXwy2vJt9vl+9JrtOUixxcnzXUNxPCztRPpIWdtW7rxZ2+Q+Tja4V
j3y9f88ZBKI8zCP03Ww2nZ0gf2B8PJ2gd+PppXuzGN6ONr8vbKL1fDi+bM425VYizku5HSP7
tDabBFJ2TKdoxbezXGTezopq9e1WOHwzknstS8If6zeyicVcIbr9fF1+88Z3d+d0NjhQJlIM
K8y1WcUQHMnSG8gWloX5UDQW3Q5g84kYeoi+eje8hHgcrOW/o+1pJW/6yvr+usUryf/P2JLW
0+Wtpv9D/p+X3v8pTML5f8KJwO78P1z3+f+7uGbT6eIvzeUVe0WkOnl8Mb1qHgdVfI7c+zx0
fMWsmapnzfXi4tR+BR7jCtuXYotmbv8mzRGW6KfZcDIf24kAHpJaS66k++AH967vFGlRa8Jb
MJww1YKh2zCsVhwLGsEQKWql9QYHvA8s6Dc4bBsHagYGigiHcngqRRmHb+OoWkH1JsJhFHCY
KeOIbRxTS0oYi3Cgo7UhsoXDqGItHJlTM4EGKfhAbXCsng0u46gcDlPa6AhHyFQ/CY7O4Qgl
nNk3OKD32nBaxjE5HCUMNhGOojv0Q1zxBMdIIWL9aNypH1DpNg6tidQ8htGd6iE1zcGAmkWM
Aw3sUg9YJocjNMU0wiGYd+qH1DwHpOASMRChOxQkckBGp0QkFO9QkdwGYsBokzCIUL1DRyoH
xJRIVMTkDhXpHI5QTCcN4nyHikwOSEmjWQwk6I5BlmERq40SMmmRxJ0qojlWc2A1ZzwB0p06
ojle85pJoxLrK9mpI5ojNq+F5InR9JafTnAyvOZ2JwlLGmToDhVleM1rIyiOjUZxt6emOV6L
mghNTAK07aplBJThtQBdY5YAkW1fHQNliC2A2DgZIZRuO+sYKENsOx0blbSIbXtrGRE7Y32Q
ABESA/Ftd90GYjliy5oYIFICtO2wY6AMsWXNKbjDGEhse+wYKNM1WUuiTQIkg8cevLCbsH6G
+NKutnkNTETHx7C4+/p6BitdyzdYfoXrCP3VvvkYXqIf7cYo9Lw5W45sLVX1/fLy0q+y5tfD
UYPmzXA2ukDnsJpfi0+adyA0uhyOr1D7OkaDyXRi/72dZjQ+HzdnmxrTRIDtkWvJusTo/eiy
QaOLZvR2noCejefDVzZN8Or9elPZBno8SZaHQfyoqpw6j981o8V0hpRE9usDH6Ezq3ObSYfK
zrziH6HGJixgyY8r0L2WYRryeI/gPrVfpM3AlIbS6KOr4cLiVBICU6E9gxcbs6HBaZA+CiUP
K3BblFNPrbAbzeceLobzC7uf7fxyPFrY3eE1LGNcQWO/VHo+vXxn5V2/5nbXV9gCt5wPXzdo
AAT4oXk9tL2cH55U1GhcW6cSruYfyzGoqrFfe9+WA9uuFDfwTf1yEGnuCE3B4Bewxj+ExisM
kadRa8uOFsvNZrxtxNH06tpmP/z2PFwb+m8b20XVDOdBUwi4rp2x7HcUUv/bqgkVzDiGg+y6
RhCwFTrlLSxR0OD4N2IOKwhXOM6UfPb9C9u80Vso6NcltiyVtux0cQHcHrgcxRAYNbqA1Ysr
PD+scI1NC/ByOl/YLXTns+HrK1CrozUoiIiacrLq42K6AP1k1FRVy8mKhWA6W2X67xWsFTXA
NltGdFDrYZdoSOSsZVc7nB6h8JJdP0IPj2G4HD/c4BOLr3fh+4xN0irK1lL3SZh/xSvN/9Al
u+P8D/hTGfI/sKaBSMblf8T9v/9yJ9c6iJFCabIrqWOkpirOxnBca8WqIk42q6M5ZXEWhVJd
G6bKOPmsDoTUOs7GEJjMjS7j5LM6BsfJIY4h8pe0DJNP6khFeYxjWI2pLOPkkzqSkzgMhrWD
nb/KOPmkDpdJgC+lgYUIL+PkkzoCx7khJVRNSYeW8zkdrtIkCkTAVHeoOZ/T4SzWjmEQvfNi
r0opHaaTzAe4n5rhYrdKOR2mcLIaJxBnMVXsVympwzhL8gPEqJqzIn9KSR261SKbQhG4SKBS
UoeCx05yKIrZRXoZKJ/UISRNNHAJlZaHRimpQ7iOuQh0NrUoj41SVgcLk6Y+mKpleXCUsjpY
qgTIpipV1/DIZ3VglkzMrwngl8dHIauDDTMJkMGgBl5UdiGrQ7XGKZA2sGYtKruQ1eGa82Rd
j5WCiYOUgbJpHakMjc3vch+GiTJQNq2jpUp4RKkAGxhTBsqmdbBgJh5rlHFagynLQNm0DoUG
JECc4ZrQ4qRYSOswJUWSsRJEw8qrQ9nZtI7giiZJFIklzB8d0302raMYTwhJpQF6kWLXsmkd
sDOFNXEMBMMDeFrsWiGt4141xkBaYZgwizwqpHVguuCxh6RG6JrjIo9Yjtmy5sboOIdm/xHE
mpdjK5ZjtoT1fZJnYuB6YW7p0HWG2C6KSvKVDCgK7Sz6NZYjtoIRQnQchTBGMEwiRb/GcsSG
iIMbwhIgo2tZnkRYjtgwo4o0O8i4tprrCLAyRoPZQoJgDCSUTT4XJxGeIzZ4Qs1SZUsJ47s8
ifAcsTX4HZ2EfAyWXDCJFLvGc8TWNZXgWWMgzTRMIh1dy+hIO2UnhDRUwmzX0bUMscHOgopY
2RxWirUpx1k8x2zbhzSlzwmGOL0cZ/Ecsw1IaEESIAPRZjnO4jlmG/D9zMTm51QZuw4oA2WY
bcDv0CQ2huhRwSTSsQTJKNsGVCoZtLAmFzCJFLsmcsw2dmlFk64JDl65PEREjtnGvmBkSYsk
g0i6PEREjtk2LwtDCz7QGyBFIF4vx1kix2xiCeNew7WANAbvUo6zRI7ZACT8S/M2kIFKcdFn
ixyzAUgJ5yFbQEbDhFOOs0SO2Xatyd2g3QAJrCBeL8dZIsds4iZaFQMRYelVnB9FjtkAxJiI
rSYodx64e3G9DSSo21nQAgJou2YqAckcs+3WC/8ergXEKcyB5ThL5pgNQFrE1heC2B0QxZ7J
PLHBq4mkQaBnmEQ6epYlNszzNKaRkNpOUh09yxKbcuxW/C0gpezbsyKNZJ7YEHiaBEhLWOmU
wyyZJzbEizyhkREQrpfDLJknNjU6NprEHINLKLo1mec1zPs6HmkSFuswADuWj9meMaZ1bDQ7
g8McUnRrKs9rJmCSj4EgFAVSFN2ayvMaFiJpi2DqB80V5xCVJzYzwuXDWkDgaaGhRWWrPLE5
gZAhBgJmgw06upYlNocQNqaRBCSYQzq6liU2By+mYyDFIZIqh1kqT2zw8ThpkWaw+C2HWSpP
bK6TISsNhWi9HGWpPLGFjfsjIIUxRHHlKMtnH7eBYEFtEiADw7scZek8scE9J0NNEQ0xYnmE
6DyxYenCYh3B7GHTbsWu6TyxhaaJW1NMYhszlYGyxJaY/F8717Jj2Q0C9/mKKKuMFEXGDx7/
lf9XivtI+nAwdyaZpVn29JSO7QIKG7pdwxFYBKW79xDNic1kYYvWQOTaiyzNec3j2X/zBYg7
ROteZGnOa/xS/CKh7nfAe6CURozfCV+kDUpnL7I0JzZblH2iimJgL7Ke9+E3ICEOLismCMp7
kWU5sWVMuQJpYxfr2+xoObFRuAYcWtDqe41lOa8F/nDdIu0TcXyvsSznNcQUXw8NQQ0fr8XK
Ul4rtaCNFMIUKaRYWkpseOwKX4RIh8xSLC0lts7g+roMUn2vsSzntbLOq4PgJx7sChaldFRl
viZHFcYu7DXW831Gb+8zDUn1CqRLvN1sf7XecqQ+A40gHRFbijv6l0fdn4zkemrWxoArF489
baRI3Nd1l4w6iLpPIkCaKRIK2uvBIdHikKs3kbbuSFCviP4akEyubXM3JE6Regv+ZsMbQqtX
kSYp0rCgIm3KuPYE3pA0RVoW6nVb7NtXrc5SJFG5ClLjBdH+6enwDoQ8Fj5JBlRH9XZIKRKR
jvBJIABqy4JOlFD88ZwZan8zgmyvXg8poTiQlgTBRa01/LzyFko4jv+Cco8jlDW/XSygUpKT
SY9fRQJhVfkLpSxHXaQRqjPke+UwlNK8B5VDqMEh3yt/oZTlHZzWADUnBPxeegEqpXmXGH+R
/EZztVk/bd+RkOsiEj4TyWWbNoGUEn3QohmgpKHc3+svv4hIoWI9ACTzt8Ft6gRSynSkf4n0
VIWS30swv9RIoaSPuFUmruW36RNQKdOHUb8mBsIBQtbudZjfkGRQs5mFryKajCRTLTBl+uyr
RyiUQZAN1QJTrs9JSgFqdIj6vRrzC5cUiilu1SSXEwWrUipAeLX4TdMg6/eCzC9vUiiLCYto
KYT9XpK5Ns6g4P2B6tDD68++12R+EZQiDQt1PZGwj9sUMW+kVF/cIpIud7Ei6I2U6ajtYkwn
G+aXawVUyvRlNsL59dah8KtMM1Kme6t+WGDHCcIDikwzUqajDLYQYHpvkPlVphkp03npDcke
F0h1d9AdSDTcW8OPBXVTJc1mynQ2CXKRoNgh9SttNlOmC0nkZ18LYr8SZzOlugyhuECe3qlT
sGqme4VMKvGrZDwK3AIq5TqUUJD71JWg98v2rpTryHbh9pG6NW9jrBaYch2aMWqFbuaTMtUC
U66jMo5hbzSF5K/cZqZc1ynhOosGCTR/5TbprqOmnRGpMzR/pdBWSnbUx+EKgaBE1CV8AZWS
3RrbCFBzMAqUIq6vlOzY3ejNY/WJZFPk0pWSHQVbRGKCCKwU2kp33V59EV+hpPlES5FMV8p1
lENTIpRC9lcSbaVcNxA7LlDFZX+16wnXvae3xRAzjH0OslpgwnVAzbbCXvnMu+utPVSyVUDi
Fkjl7x3w1mJ5nFAdSBqvAWh6h/aqBBonVIe+aF1DVJjepM2VQuOE6oCCwo5Q3qjNlUTjhOqA
mtziAqchslYSjROuD58MD49T0HnavC+0gEoPkKz1eILMitRRhD1OuD5QhDWLe4VkhmxTte6m
XO9jxCLQ+zmrNnu/JE+hFsciadroj1b7MwX5aQpSZzoF+dj6r1OQvvvrVQU88f6Zgnz8gYbX
5dj7n95TkDgeaS9F9de/55ZNQXqwfl9XlFOQ3bvXvQKl9h+mIIn7s9h5bdTPmYJ0yvng7XsM
8semIF37fc8U5Gtk9f9NQUJdtNY+TEHSc47q2y/DH13bhzlIhRN+nIPEFqEggAZ8rfKnzEE+
Zhn7eI8yyh+//vY7fYtzjGdO8tixY8eOHTt27NixY8eOHTt27NixY8eOHTt27NixY8eOHfth
+xulN40OAMgAAA==

--k1lZvvs/B4yU6o8G--
